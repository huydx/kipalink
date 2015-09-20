module UsersHelper
  def has_avatar?(user)
   !user.avatar_url.blank?
  end
end
