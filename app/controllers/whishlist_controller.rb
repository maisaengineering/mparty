class WhishlistController < ApplicationController
  before_filter :auth_user
  before_action :find_wishlist
  before_action :check_authorization # only event owner can add or remove products
  skip_before_filter :verify_authenticity_token, only: [:add_product,:remove_product,:update_quantity]


  #GET '/event/:event_id/whishlist'
  def index
    @wishlist= @event.wishlist.nil?  ? Spree::Wishlist.create(event_id: params[:event_id], name: @event.name, user_id: spree_current_user.id) :  @event.wishlist
    #session[:wishlist_id] = @wishlist.id
    @products = Spree::Product.all
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end


  # POST '/event/:event_id/wishlist/add_product'
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
    render nothing: true
  end

  # DELETE '/event/:event_id/wishlist/remove_product'
  def remove_product
    wished_product = @wishlist.wished_products.where(variant_id: params[:variant_id]).first
    wished_product.destroy if wished_product
    render nothing: true
  end

  #GET /wishlist/:wishlist_id/wished_products
  def wished_products
    render layout: false
  end

  # POST /event/:event_id/wishlist/update-product-quantity
  def update_quantity
    wished_product = @wishlist.wished_products.where(variant_id: params[:variant_id].to_i).first
    if wished_product.update_attribute(:quantity, params[:quantity])
      flash.now[:success] = "Quantity updated successfully"
    else
      flash.now[:error] = wished_product.errors.full_messages.to_sentence
    end
  end

  private


  def find_wishlist
    begin
      @event = Event.find(params[:event_id])
      @wishlist =  @event.wishlist
    rescue
      (render text: 'No event found') and return
    end
  end

  def check_authorization
    (render text: 'Access Denied') and return unless @event.is_owner?(spree_current_user)
  end
end
