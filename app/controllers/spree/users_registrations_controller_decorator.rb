Spree::UserRegistrationsController.class_eval do
  skip_before_filter :auth_user
  def create
    @user = build_resource(spree_user_params)
    #@user.first_name = params[:spree_user][:email].split('@')[0]
    if resource.save
      set_flash_message(:notice, :signed_up)
      update_orders_and_invitations(@user)
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
    def update_orders_and_invitations(user)
      orders = Spree::Order.where(email: user.email)
      invitations = Invite.where(recipient_email: user.email)
     
      # Update purcahsed orders 
      if orders.size > 0
        orders.each do |order|
          order.created_by_id = user.id
          order.user_id = user.id
          order.save
        end
      end

      # Update Invitations
      if invitations.size > 0
        invitations.each do |invite|
          invite.user_id = user.id  
        end
      end  

    end  

    def spree_user_params
      params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes, :first_name, :last_name, :phone)
    end
end