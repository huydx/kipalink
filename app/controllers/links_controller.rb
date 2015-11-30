class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :vote]

  def index
    @nextPageNo = params[:page].to_i + 1
    @links = Link.fetch_links(params[:page])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    @link.user = current_user
    if @link.save
      redirect_to root_path
    end
  end

  def show
    @comment = LinkComment.new
    @link = Link.find(params[:id])
    @comments = @link.link_comment.hash_tree
  end

  def vote
    @link = Link.find(params[:link_id])
    if @link
      unless Vote.voted?(current_user, @link)
        v = Vote.create(link_id: @link.id, user_id: current_user.id)
      end
    end
    redirect_to links_path
  end

  private
  def link_params
    params.require(:link).permit(:id, :title, :url, :description)
  end
end
