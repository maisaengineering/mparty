Spree::OrdersController.class_eval do

  #Overriding populate action to add multiple items to a cart at a time
  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    # Save event id in session for further reference(shipping address etc)
    session[:event_id] = params[:event_id]
    session[:invitation_id] ||= params[:invitation_id]
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    @flag = false
    params[:variant_id].each_with_index do |item,i|
      if params[:quantity]["#{i}"].to_i > 0
        populator.populate(params[:variant_id]["#{i}"].to_i, params[:quantity]["#{i}"].to_i)
        @flag = true
      end
    end

    if @flag
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
end