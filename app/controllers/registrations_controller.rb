#custom devise registration controller
class RegistrationsController < Devise::RegistrationsController
  before_action :no_header
  include Devise::Controllers::Rememberable

  def new
    redirect_to Rails.configuration.kipalink.signup
  end
end
