class WishlistController < ApplicationController

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::SSL
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Search
  include Spree::Core::ControllerHelpers::StrongParameters
  include Spree::Core::ControllerHelpers::Order


  before_filter :auth_user
  before_action :find_wishlist
  skip_before_filter :verify_authenticity_token, only: [:add_product,:remove_product,:update_quantity]

  helper 'spree/taxons'
  #GET '/event/:event_id/wishlist'
  def index
    @wishlist= @event.wishlist.nil?  ? Spree::Wishlist.create(event_id: params[:event_id], name: @event.name, user_id: spree_current_user.id) :  @event.wishlist
    session[:wishlist_id] = @wishlist.id
    authorize @wishlist, :show?
    #session[:wishlist_id] = @wishlist.id
    @s_address = spree_current_user.events.order(created_at: :desc).offset(1).first.try(:shipping_address)
    @searcher = build_searcher(params)
    @products = @searcher.retrieve_products
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end


  # POST '/event/:event_id/wishlist/add_product'
  def add_product
    authorize @wishlist, :add_products?
    if @wishlist.include? params[:variant_id]
      wished_product = @wishlist.wished_products.detect {|wp| wp.variant_id == params[:variant_id].to_i }
    else
      wished_product = @wishlist.wished_products.build(variant_id: params[:variant_id])
    end
    wished_product.wishlist = @wishlist
    wished_product.quantity =  params[:quantity] || 1
    wished_product.save!
    @wishlist.event.update_attribute(:has_wishlist,true) if @wishlist and @wishlist.event
    respond_to do |format|
      format.js{ render nothing: true }
      format.html{
        redirect_to event_wishlist_url(event_id: @event.id),notice: 'Product added to wishlist'
      }
    end


  end

  # DELETE '/event/:event_id/wishlist/remove_product'
  def remove_product
    authorize @wishlist, :remove_products?
    wished_product = @wishlist.wished_products.where(variant_id: params[:variant_id]).first
    wished_product.destroy if wished_product
    render nothing: true
  end

  #GET /event/:event_id/wishlist/wished_products
  def wished_products
    authorize @wishlist, :show_wished_products?
    render layout: false
  end

  # POST /event/:event_id/wishlist/update-product-quantity
  def update_quantity
    authorize @wishlist, :update_quantity?
    wished_product = @wishlist.wished_products.where(variant_id: params[:variant_id].to_i).first
    if wished_product.update_attribute(:quantity, params[:quantity])
      flash.now[:success] = "Quantity updated successfully"
    else
      flash.now[:error] = wished_product.errors.full_messages.to_sentence
    end
  end

  def shipping_address
    authorize @event, :add_ship_address?
    if @event.shipping_address_id.present?
      @ship_address = @event.ship_address
      @ship_address.update_attributes(address_params)
    else
      @ship_address =  Spree::Address.new(address_params)
      @event.update_attribute(:shipping_address_id,@ship_address.id) if @ship_address.save
    end
    if @ship_address.errors.any?
      flash.now[:error] = "Errors: #{@ship_address.errors.full_messages.to_sentence}"
    else
      flash.now[:success] = "Shipping address updated successfully"
    end
  end

  private

  def address_params
    params.require(:ship_address).permit(:firstname, :lastname,:address1,:address2,
                                         :city,:zipcode,:phone,:alternative_phone,:country_id,:state_id)
  end


  def find_wishlist
    begin
      @event = Event.find(params[:event_id])
      @wishlist =  @event.wishlist
    rescue
      flash[:error] = "No event found"
      redirect_to spree.root_url and return
    end
  end


end
