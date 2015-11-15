#custom devise registration controller
class SessionsController < Devise::SessionsController
  before_action :no_header

  def new
    redirect_to Rails.configuration.kipalink.authurl +
      '?next_url=' + Rails.configuration.kipalink.domain
  end
end
