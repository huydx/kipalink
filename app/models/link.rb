class Link < ActiveRecord::Base
  belongs_to :user
  has_many :link_comment
  self.per_page = 10
end
