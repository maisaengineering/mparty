class AccountController < ApplicationController
  before_filter :auth_user
  before_action :set_user, only: [:show,:edit_profile,:update_profile]

  def show

  end

  def edit_profile

  end

  def update_profile
    if(params[:user][:avatar].present?)
    @user.update_attributes(avatar: params[:user][:avatar])
    end
    @user.update_attributes(user_params)
    redirect_to account_show_path
  end


private
  def set_user
    @user = spree_current_user
  end

  def user_params
    params.require(:user).permit(:email,:first_name,:last_name,:phone,:address,:city,:state,:country)
  end

end