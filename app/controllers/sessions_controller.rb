#custom devise registration controller
class SessionsController < Devise::SessionsController
  before_action :no_header

  def new
    @resource ||= User.new
    render :layout => false
  end

  def create
    super
  end

  def update
    super
  end
end
