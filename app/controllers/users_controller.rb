# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:mypage]
  before_action :find_other_id, only: [:follow, :unfollow]

  def show
    @focus = 'basic'
  end

  def update_basic
    if current_user.update(basic_params)
      flash.now[:basic_success] = "Cập nhật profile thành công !"
    else
      msg = current_user.errors.messages.map{|k,v| "#{k.to_s} #{v.first}"}.flatten.join("\n")
      flash.now[:basic_error] = msg || "Không thể cập nhật"
    end
    @focus = 'basic'
    render 'show'
  end

  def update_password
    if current_user.update_with_password(password_params)
      sign_in current_user, :bypass => true
      flash.now[:password_success] = "Đổi password thành công !"
    else
      flash.now[:password_error] = "Password hiện tại không chính xác"
    end
    @focus = 'password'
    render "show"
  end

  private

  def basic_params
    params.require(:user).permit(:email, :name, :handle_name, :avatar_url)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def find_other_id
    @other = User.find_by_id(params[:other_id])
  end

  def response_for_user_follow
    { other:  @other.follow_resource,
      me:     current_user.follow_resource }
  end
end
