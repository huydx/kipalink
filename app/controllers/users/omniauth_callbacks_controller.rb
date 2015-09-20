class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  before_action :user_from_request
  before_action :no_header

  def facebook
    login_from_oauth(:facebook)
  end

  def twitter
    login_from_oauth(:twitter)
  end

  def github
    login_from_oauth(:github)
  end

  private
  def user_from_request
    @user = User.from_omniauth(request.env["omniauth.auth"])
  end

  def login_from_oauth(provider)
    if @user.persisted?
      remember_me(@user)
      sign_in_and_redirect @user, event: :authentication
    else
      render 'devise/registrations/social'
    end
  end
end
