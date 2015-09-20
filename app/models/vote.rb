class Vote < ActiveRecord::Base
  belongs_to :link
  belongs_to :user

  def self.voted?(user, link)
    Vote.exists?(["user_id = ? AND link_id = ?", user.id, link.id])
  end
end
