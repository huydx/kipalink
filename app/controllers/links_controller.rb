class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]  
  
  def index
    @links = Link.paginate(:page => params[:page]).order('created_at DESC')
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
    @comments = @link.link_comment
  end

  private
  def link_params
    params.require(:link).permit(:id, :title, :url, :description)
  end
end
