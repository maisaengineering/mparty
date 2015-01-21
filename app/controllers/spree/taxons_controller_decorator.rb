Spree::TaxonsController.class_eval do
  before_action :check_wishlist

  private
  def check_wishlist
    begin
      @wishlist = Spree::Wishlist.find(session[:wishlist_id])
      @event = @wishlist.event
    rescue
      flash[:error] = "Create wishlist for an event before continue"
      redirect_to spree.root_url
    end
  end
end
