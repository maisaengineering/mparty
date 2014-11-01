Spree::WishedProductsController.class_eval do
	def create
		@wished_product = Spree::WishedProduct.new(wished_product_attributes)
		@wishlist = session[:wishlist_id].present? ? Spree::Wishlist.find(session[:wishlist_id]) : spree_current_user.wishlist
		if @wishlist.include? params[:wished_product][:variant_id]
			@wished_product = @wishlist.wished_products.detect {|wp| wp.variant_id == params[:wished_product][:variant_id].to_i }
		else
			@wished_product.wishlist = @wishlist
			@wished_product.save
      @wishlist.event.update_attribute(:has_wishlist,true) if @wishlist and @wishlist.event
		end
		if !session[:wishlist_id].present?
			respond_with(@wished_product) do |format|
				format.html { redirect_to wishlist_url(@wishlist) }
			end  
		else
			session[:wishlist_id] = nil
			redirect_to "/events/add_guests/#{@wishlist.event_id}"
		end    
		
	end

	private

	def wished_product_attributes
		params.require(:wished_product).permit(:variant_id, :wishlist_id, :quantity)
	end
end