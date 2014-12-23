Spree::OrdersController.class_eval do
	
	#Overriding populate action to add multiple items to a cart at a time
	# Adds a new item to the order (creating a new order if none already exists)
    def populate
      populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)

      flag = false

      params[:variant_id].each_with_index do |item,i|
      	if params[:quantity]["#{i}"].to_i > 0
      		populator.populate(params[:variant_id]["#{i}"].to_i, params[:quantity]["#{i}"].to_i)
      		flag = true
      	end	
      end	

      if flag
        respond_with(@order) do |format|
          format.html { redirect_to cart_path }
        end
      else
        flash[:error] = 'Please select quantity'  #populator.errors.full_messages.join(" ")
        redirect_to :back
      end
    end
end