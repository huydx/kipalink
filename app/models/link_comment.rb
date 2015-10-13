class LinkComment < ActiveRecord::Base
  has_closure_tree

  belongs_to :link
  belongs_to :user
end
