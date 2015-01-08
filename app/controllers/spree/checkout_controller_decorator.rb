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
          @order_owner = spree_current_user
          if @order_owner.nil? # no user => logged in as guest
            # try to fetch user from invitation if came here via invitation link
            invitation = Invite.find(session[:invitation_id])
            @order_owner = Spree::User.find_by_email(invitation.try(:recipient_email)) if invitation
          end
          # --------
          unless @order.variants.blank?
            @order.variants.each do |variant|
              wished_product = Spree::WishedProduct.where(variant_id: variant.id, wishlist_id: wishlist.id).first
              if wished_product
                wished_product.quantity_purchased = wished_product.quantity_purchased + @order.line_items.first.quantity
                if wished_product.quantity - @order.line_items.first.quantity == 0
                  wished_product.is_purchased = true
                end
                wished_product.save
                #TODO create reference of wished product for this order
              end
            end
          end

          if @order_owner.present?
            @order.created_by_id = @order_owner.id
            @order.user_id = @order_owner.id
            @order.save
            flash.notice = Spree.t(:order_processed_successfully)
            flash[:commerce_tracking] = "nothing special"
            # redirect_to  completion_route
          else # Checked out as guest
            flash[:notice] = "Order has been placed successfully. If you want to track this order please signup."
            # redirect_to  spree.signup_path(:invite_email => @order.email)
          end
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