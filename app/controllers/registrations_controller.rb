#custom devise registration controller
class RegistrationsController < Devise::RegistrationsController
  before_action :no_header
  include Devise::Controllers::Rememberable

  def new
    super
  end

  def create
    case params[:from]
    when 'home'
      keep_password_and_redirect
    when 'social'
      build_social_user_base_on_params
    else
      super
    end
  end

  def update
    super
  end

  def after_sign_up_path_for(resource)
    recommend_tag_users_path
  end

  private
  def keep_password_and_redirect
    #TODO if user persisted what to do?
    build_resource(sign_up_params)
    resource.password = sign_up_params.fetch :password #keep password from home
    render 'devise/registrations/new'
  end

  def build_social_user_base_on_params
    @user = User.create(user_params)

    if @user.persisted?
      sign_in(@user)
      @user.remember_me!
      redirect_to posts_path
    else
      render 'devise/registrations/social'
    end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :provider,
      :uid,
      :password,
      :email,
      :avatar_url,
      :facebook_url,
      :github_url,
      :twitter_url
    )
  end

  def sign_up_params
    params.require(:user).permit(
      :password,
      :password_confirmation,
      :email,
      :name,
    )
  end
end
