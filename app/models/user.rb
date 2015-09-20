class User < ActiveRecord::Base
  DEFAULT_NICKNAME  = 'kipalog'
  DEFAULT_EMAIL     = 'foo@bar.com'

  before_validation :create_handle_name

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

  has_many :comments
  has_many :links
  has_many :link_comments

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

  def avatar_url_path
    self.avatar_url.blank? ? ActionController::Base.helpers.asset_path('common/male_avatar.png') : self.avatar_url
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
end
