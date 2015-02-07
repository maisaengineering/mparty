class AccountController < ApplicationController
  before_filter :auth_user
  before_action :set_user, only: [:show,:edit_profile,:update_profile, :update_avatar]

  def show

  end

  def edit_profile

  end

  def update_profile
    if @user.update_attributes(user_params)
    redirect_to account_show_path
    else
      render "edit_profile"
    end
  end

  def update_avatar
    if(params[:user][:avatar].present?)
      @user.update_attributes(avatar: params[:user][:avatar])
      redirect_to account_show_path
    else
      render "show"
    end
  end


private
  def set_user
    @user = spree_current_user
  end

  def user_params
    params.require(:user).permit(:email,:nickname,:first_name,:last_name,:phone,:address,:city,:state_id,:country_id,:zipcode)
  end

end