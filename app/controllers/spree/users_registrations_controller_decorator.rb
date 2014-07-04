Spree::UserRegistrationsController.class_eval do
  def create
    @user = build_resource(spree_user_params)
    if resource.save
      set_flash_message(:notice, :signed_up)
      sign_in(:spree_user, @user)
      session[:spree_user_signup] = true
      associate_user
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      render :new
    end
  end
end