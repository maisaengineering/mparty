class WhishlistController < ApplicationController
  before_filter :auth_user
  skip_before_filter :verify_authenticity_token, only: [:add_product,:remove_product]
  before_action :find_wishlist,except: :index

  #GET '/event/:event_id/whishlist'
  def index
    @event = Event.find(params[:event_id])
    @wishlist= @event.wishlist.nil?  ? Spree::Wishlist.create(event_id: params[:event_id], name: @event.name, user_id: spree_current_user.id) :  @event.wishlist
    #session[:wishlist_id] = @wishlist.id
    @products = Spree::Product.all
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end


  # POST '/wishlist/:wishlist_id/add_product'
  def add_product
    if @wishlist.include? params[:variant_id]
      wished_product = @wishlist.wished_products.detect {|wp| wp.variant_id == params[:variant_id].to_i }
    else
      wished_product = @wishlist.wished_products.build(variant_id: params[:variant_id])
    end
    wished_product.wishlist = @wishlist
    wished_product.quantity =  params[:quantity] || 1
    wished_product.save
    @wishlist.event.update_attribute(:has_wishlist,true) if @wishlist and @wishlist.event
    #end
    render nothing: true
  end

  # DELETE '/wishlist/:wishlist_id/remove_product'
  def remove_product
    wished_product = @wishlist.wished_products.where(variant_id: params[:variant_id]).first
    wished_product.destroy if wished_product
    render nothing: true
  end

  #GET /wishlist/:wishlist_id/wished_products
  def wished_products
    render layout: false
  end

  private
  def find_wishlist
    @event = Event.find(params[:event_id])
    @wishlist =  @event.wishlist
  end

end
