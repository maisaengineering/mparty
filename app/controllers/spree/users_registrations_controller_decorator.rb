Spree::UserRegistrationsController.class_eval do
  skip_before_filter :auth_user
  def create
    @user = build_resource(spree_user_params)
    if resource.save
      set_flash_message(:notice, :signed_up)
      update_orders(@user)
      sign_in(:spree_user, @user)
      session[:spree_user_signup] = true
      associate_user
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  private
    def update_orders(user)
      orders = Spree::Order.where(email: user.email)
      if orders.size > 0
        orders.each do |order|
          order.created_by_id = user.id
          order.user_id = user.id
          order.save
        end
      end  
    end  
end