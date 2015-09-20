class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def allcomments
    @link_comment = LinkComment.all.order('created_at DESC')
  end
  
  def create
    @link = Link.find(params[:link_id])
    if @link
      @link_comment = LinkComment.new(post_params)
      @link_comment.link = @link
        @link_comment.user = current_user
      if @link_comment.save
        redirect_to link_path(@link)
      end
    end
  end

  private
  def post_params
    params.require(:link_comment).permit(:link_id, :content)
  end
end
