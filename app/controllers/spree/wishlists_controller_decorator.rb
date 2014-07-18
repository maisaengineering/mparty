Spree::WishlistsController.class_eval do
  before_filter :auth_user


  def new
    @wishlist = Spree::Wishlist.new(event_id: params[:event_id])
    respond_with(@wishlist)
  end

  def create
    @wishlist = Spree::Wishlist.new wishlist_attributes
    @wishlist.user = spree_current_user
    @wishlist.event = Event.find(params[:wishlist][:event_id]) if params[:wishlist][:event_id]

    @wishlist.save
    respond_with(@wishlist)
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