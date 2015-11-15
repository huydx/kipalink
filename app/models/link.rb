class Link < ActiveRecord::Base
  belongs_to :user
  has_many :link_comment
  has_many :vote

  self.per_page = 30
end
