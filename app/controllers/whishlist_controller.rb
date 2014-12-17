class WhishlistController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :add_product

  #GET '/event/:event_id/whishlist'
  def index
    @event = Event.find(params[:event_id])
    @wishlist= @event.wishlist.nil?  ? Spree::Wishlist.create(event_id: params[:event_id], name: @event.name, user_id: spree_current_user.id) :  @event.wishlist
    session[:wishlist_id] = @wishlist.id
    @products = Spree::Product.all
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end


  def add_product
    @wished_product = Spree::WishedProduct.new
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

end
