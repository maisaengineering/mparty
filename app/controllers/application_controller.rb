class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def auth_user
    redirect_to spree_login_path unless signed_in?
  end
end
