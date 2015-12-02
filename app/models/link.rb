class Link < ActiveRecord::Base
  belongs_to :user
  has_many :link_comment
  has_many :vote

  # Number of links per page
  WillPaginate.per_page = 20

  def self.newlinks(page)
    Link.order('created_at DESC').paginate(:page => page)
  end

  def self.hotlinks(page)
    Link.order('point DESC').paginate(:page => page)
  end
end
