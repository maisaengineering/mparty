class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_filter :change_url

 #def change_url
   #if request.original_url.include?('/?invitation_code')
    # redirect_to registration_path
   #end
 #end

end
