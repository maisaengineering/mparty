Spree::WishlistsController.class_eval do
  before_filter :auth_user


  def new
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      @wishlist = Spree::Wishlist.create(event_id: params[:event_id], name: @event.name, user_id: spree_current_user.id)
      flash[:notice] = "Please provide Shipping Address for your Wishlist #{@wishlist.name}." 
      render "/events/shipping_address" and return
    else
      @wishlist = Spree::Wishlist.new
    end  
    respond_with(@wishlist)
  end

  def create
    @wishlist = Spree::Wishlist.new wishlist_attributes
    @wishlist.user = spree_current_user
    @wishlist.event_id = params[:wishlist][:event_id] if params[:wishlist][:event_id]

    if @wishlist.save
      if params[:wishlist][:event_id]
        redirect_to "/events/#{params[:wishlist][:event_id]}/add_products"
      else  
        respond_with(@wishlist)
      end  
    end  
  end

  def show
    @wishlist = Spree::Wishlist.find_by_access_hash(params[:id])
    respond_with(@wishlist)
  end

  private

  def wishlist_attributes
    params.require(:wishlist).permit(:name, :is_default, :is_private, :event_id)
  end

  def find_wishlist
    @wishlist = Spree::Wishlist.find_by_access_hash(params[:id])
  end
end