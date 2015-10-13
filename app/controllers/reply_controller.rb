class ReplyController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @comment = LinkComment.find(params[:comment_id])
    @reply = LinkComment.new
  end

  def create
    @comment = LinkComment.find(params[:comment_id])
    @reply = LinkComment.new(post_params)
    @reply.link = @comment.link
    @reply.user = current_user
    @comment.children << @reply
    @reply.save
    @comment.save
    redirect_to link_path(@comment.link)
  end

  private
  def post_params
    params.require(:link_comment).permit(:content)
  end
end
