Spree::OrdersController.class_eval do

  #Overriding populate action to add multiple items to a cart at a time
  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    # replace previous cart items with new if exists
    if params[:event_id].present?
      if simple_current_order
        simple_current_order.update_attribute(:event_id,params[:event_id].to_i) if params[:event_id].present? #Assign event to order
        simple_current_order.empty! # Empty the cart (remove all line items and create again) due to not supporting multiple wishlist adding to cart
      end
      # add shipping-address to order
      current_order.update_attribute(:ship_address_id,Event.find(params[:event_id]).shipping_address_id) rescue nil
    end


    @flag = false
    params[:variant_id].each_with_index do |item,i|
      if params[:quantity]["#{i}"].to_i > 0
        populator.populate(params[:variant_id]["#{i}"].to_i, params[:quantity]["#{i}"].to_i)
        @flag = true
      end
    end

    if @flag
      # Save event id in session for further reference(shipping address etc)
      session[:invitation_id] = params[:invitation_id]
      flash[:success] = 'Items added to cart please checkout'
    else
      flash.now[:error] = 'Please select quantity'  #populator.errors.full_messages.join(" ")
    end

    respond_with(@order) do |format|
      format.html {
        if @flag
          redirect_to cart_path
        else
          redirect_to :back
        end
      }
      format.js{}
    end

  end

  def empty
    if @order = current_order
      @order.empty!
      @order.update_attribute(:item_count,0)
    end

    redirect_to spree.cart_path
  end


end