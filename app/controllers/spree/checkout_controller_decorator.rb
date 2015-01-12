Spree::CheckoutController.class_eval do

  before_filter :register_handlebars,only: [:edit]
  def update
    if @order.update_from_params(params, permitted_checkout_attributes)
      persist_user_address
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        if session[:event_id].present?
          event = Event.find(session[:event_id])
          wishlist = event.wishlist
          logged_in_user = spree_current_user
          if logged_in_user.nil? # no user => logged in as guest
            # try to fetch user from invitation if came here via invitation link
            invitation = Invite.find(session[:invitation_id])
            logged_in_user = Spree::User.find_by_email(invitation.try(:recipient_email)) if invitation
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
          end
          session[:order_id] = nil
          session.delete(:event_id)
          session.delete(:invitation_id)
          flash[:success] = Spree.t(:order_processed_successfully)
          redirect_to  completion_route and return
        else
          session[:order_id] = nil
          flash.notice = Spree.t(:order_processed_successfully)
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
      if session[:event_id].present?
        event = Event.find(session[:event_id])
        ship_address = event.shipping_address
        @order.ship_address = ship_address
      else
        @order.ship_address ||= Spree::Address.default(try_spree_current_user, "ship")
      end
    end
  end
end