Spree::CheckoutController.class_eval do
  def update
    if @order.update_from_params(params, permitted_checkout_attributes)
      persist_user_address
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        puts "###", session[:event_id]
        if session[:event_id]
          wishlist = Spree::Wishlist.find_by(event_id: session[:event_id])
          @order.variants.each do |variant|
            wp = Spree::WishedProduct.where(variant_id: variant.id, wishlist_id: wishlist.id).first
            wp.is_purchased= true
            wp.save
          end
        end
        session[:order_id] = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end
end