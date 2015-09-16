class User < ActiveRecord::Base
  DEFAULT_NICKNAME  = 'kipalog'
  DEFAULT_EMAIL     = 'foo@bar.com'

  before_validation :create_handle_name

  include UserFollowable
  include TagFollowable
  include UuidPrimary

  validates :handle_name, :uniqueness => true
  validates :handle_name, :presence => true

  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :omniauthable, :omniauth_providers => [:facebook, :twitter, :github]

  has_many :posts
  has_many :comments
  has_many :like_comment

  # For user-involve-organization association
  has_many :involvements
  has_many :organizations, through: :involvements

  # For user-watch-organization association
  has_many :watchings

  has_many :notifications, class_name: 'Notification', foreign_key: 'to_user'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.avatar_url = auth.info.image

      case auth.provider
      when "github"; user.github_url = auth.extra.raw_info.html_url
      when "facebook"; user.facebook_url = auth.extra.raw_info.link
      when "twitter";
      else
      end
    end
  end

  #https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  def self.new_with_session(params, session)
    super.tap do |user|
      provider = session["devise.provider"]
      if data = session["devise.#{provider}_data"] &&
        session["devise.#{provider}_data"]["extra"]["raw_info"]

        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def remember_me
    true
  end

  def self.hot_by_score_periodic(num)
    User.order("score_periodic DESC").limit(num)
  end

  def avatar_url_path
    self.avatar_url.blank? ? ActionController::Base.helpers.asset_path('common/male_avatar.png') : self.avatar_url
  end

  def total_likes_from_post
    self.posts.joins(:users).size
  end

  def comment_to_my_post_count
    Post.joins(:comments).where(user_id: self.id).count
  end

  def like_to_my_post_count
    Post.joins(:likes).where(user_id: self.id).count
  end

  #statistic of post tag to display in mypage
  def post_tag_statistic
    tags_stat =
      published_post_tags_ids.group_by{|t| t}.map{|t,arr| [t, arr.count]}.to_h
    tags = published_post_tags.map{|t| [t.id, t]}.to_h

    #merging
    tags.merge!(tags_stat) do |tag, tag_val, tag_stat_val|
      {
        title:  tag_val.name,
        value:  tag_stat_val,
        color:  tag_val.color
      }
    end.map{|k,v| v}
  end

  def last_access_time(pagekey)
    # Get user's last access time on cache
    return $redis.hmget("user_#{self.id}", pagekey)[0]
  end

  def set_access_time(pagekey)
    # Update user's last access time value on cache to Time.now
    $redis.hmset("user_#{self.id}", pagekey, Time.now.to_i)
  end

  def total_view_count
    $redis.get("total_view_for_user_#{self.id}") || 0
  end

  def has_facebook?
    self.provider == 'facebook'
  end

  def has_github?
    self.provider == 'github'
  end

  def has_twitter?
    self.provider == 'twitter'
  end

  def watching?(org)
    Watching.exists?(organization_id: org.id, user_id: self.id)
  end

  def liked?(post)
    Like.exists?(post_id: post.id, user_id: self.id)
  end

  def published_post_tags
    @published_post_tags ||= Tag.where(id: published_post_tags_ids)
  end

  def published_post_tags_ids
    published_ids     = self.posts.published.pluck(:id)
    @published_tag_ids ||= ActsAsTaggableOn::Tagging.where(taggable_id: published_ids, taggable_type: :Post).pluck(:tag_id)
  end

  def create_handle_name
    return unless self.handle_name.blank?
    self.handle_name =
      normalize(self.name) || name_from_email || "defaultHandle"
    while(User.find_by_handle_name(self.handle_name))
      self.handle_name = "#{self.handle_name}1"
    end
  end


  def normalize(name)
    VietnameseService.normalize_strip_space(name)
  end

  def name_from_email
    ret = self.email.split("@")[0].gsub(/\W/,"")
    ret.blank? ? nil : ret
  rescue
    nil
  end

  def mentionable_range(post_id)
    post = Post.find_by_id(post_id)
    author = post.user
    commentted_users_id = post.comments.pluck(:user_id)
    (self.following + [author] + User.where('id' => commentted_users_id )).uniq
  rescue
    []
  end

  def build_mentionable_response
    {
      "name" => self.name,
      "handle_name" => self.handle_name,
      "avatar_url" => self.avatar_url_path
    }
  end
end
