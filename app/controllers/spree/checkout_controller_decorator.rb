Spree::CheckoutController.class_eval do

  before_filter :register_handlebars,only: [:edit]
  def update
    if @order.update_from_params(params, permitted_checkout_attributes)
      # persist_user_address
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        if @order.event
          event = @order.event
          wishlist = event.wishlist
          logged_in_user = spree_current_user
          if logged_in_user.nil? # no user => logged in as guest
            # try to fetch user from invitation if came here via invitation link
            if session[:invitation_id].present?
              invitation = Invite.find(session[:invitation_id])
              logged_in_user = Spree::User.find_by_email(invitation.try(:recipient_email)) if invitation
            end
          end
          # --------
          unless @order.line_items.blank?
            @order.line_items.each do |line_item|
              variant = line_item.variant
              wished_product = Spree::WishedProduct.where(variant_id: variant.id, wishlist_id: wishlist.id).first
              if wished_product
                wished_product.quantity_purchased +=  line_item.quantity
                wished_product.is_purchased = true  if wished_product.quantity >= wished_product.quantity_purchased
                if wished_product.save
                  # create Wishlist Orders( holds which products buy for which wislist and the quantity of products )
                  wished_product.wishlist_orders.create(wishlist: wishlist,order: @order,quantity_purchased: line_item.quantity)
                end
              end
            end
          end
          if logged_in_user.present?
            @order.created_by_id = logged_in_user.id
            @order.user_id = logged_in_user.id
            @order.save
            logged_in_user.update_attribute(:bill_address_id,@order.bill_address.id)
            flash[:success] = Spree.t(:order_processed_successfully)
          else
            # flash[:success] = "Thank you for placing order(#{@order.number}), to track your order sign up or login with your account."
          end
          send_order_info_to_users(@order)
          session[:order_id] = nil
          session.delete(:invitee_email)
          session.delete(:invitation_id)
          redirect_to  completion_route and return
        else
          session[:order_id] = nil
          flash[:success]= Spree.t(:order_processed_successfully)
          flash[:commerce_tracking] = "nothing special"
          redirect_to completion_route and return
        end
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

  # Skip setting ship address if order doesn't have a delivery checkout step
  # to avoid triggering validations on shipping address
  def before_address
    @order.bill_address ||= Spree::Address.default(try_spree_current_user, "bill")
    if @order.checkout_steps.include? "delivery"
      if @order.event
        ship_address = @order.event.shipping_address
        @order.ship_address = ship_address
      else
        @order.ship_address ||= Spree::Address.default(try_spree_current_user, "ship")
      end
    end
  end

  #sending emails to user and invited users
  private
  def send_order_info_to_users(order)
    event = Event.find(order.event_id)
    InvitationNotifier.delay.email_after_purchase_to_inviter(event.id,order.id)
    invites_list = event.invites.where.not("joined =? OR recipient_email =? ",2,order.email)
    invites_list.each do |invite|
      InvitationNotifier.delay.email_after_purchase_to_invitees(event.id,order.id,invite.id)
    end
  end



end