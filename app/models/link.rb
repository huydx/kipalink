class Link < ActiveRecord::Base
  belongs_to :user
  has_many :link_comment
  has_many :vote

  # Number of links per page
  WillPaginate.per_page = 4

  def self.fetch_links(page)
    Link.order('point').paginate(:page => page)
  end
end
