Spree::WishedProductsController.class_eval do
  def create
    @wished_product = Spree::WishedProduct.new(wished_product_attributes)
    @wishlist = spree_current_user.wishlist
    if @wishlist.include? params[:wished_product][:variant_id]
      @wished_product = @wishlist.wished_products.detect {|wp| wp.variant_id == params[:wished_product][:variant_id].to_i }
    else
      @wished_product.wishlist = spree_current_user.wishlist
      @wished_product.save
    end
    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wishlist) }
    end
  end
end