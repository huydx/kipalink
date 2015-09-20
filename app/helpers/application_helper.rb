module ApplicationHelper
  def link_voted(user, link)
    Vote.voted?(user, link)
  end
end
