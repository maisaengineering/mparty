Spree::CheckoutController.class_eval do
  def update
    if @order.update_from_params(params, permitted_checkout_attributes)
      persist_user_address
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        if session[:event_id]
          wishlist = Spree::Wishlist.find_by(event_id: session[:event_id])
          @order.variants.each do |variant|
            wp = Spree::WishedProduct.where(variant_id: variant.id, wishlist_id: wishlist.id).first
            wp.is_purchased= true
            wp.save
          end

          flash[:notice] = "Order has been placed successfully. If you want to track this order please signup."
          @event = wishlist.event
          session[:event_id] = nil
          redirect_to  spree.signup_path(:invite_email => @order.email)
        else
          session[:order_id] = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash[:commerce_tracking] = "nothing special"
          redirect_to completion_route
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