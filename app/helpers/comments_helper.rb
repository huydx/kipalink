module CommentsHelper
  def comments_tree_for(comments)
    comments.map do |comment, nested_comments|
      content_tag(:li,
                  content_tag(:div,
                              render(template: 'links/_comment.html.erb', locals: {comment: comment}) +
                              (nested_comments ?
                               content_tag(:ol, comments_tree_for(nested_comments), class: "comments") :
                               nil),
                              class: 'main'),
                  class: 'item')
    end.join.html_safe
  end
end
