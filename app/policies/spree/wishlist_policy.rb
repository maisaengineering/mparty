class Spree::WishlistPolicy < Struct.new(:user, :wishlist)


  def add_products?
    wishlist and  wishlist.event.is_owner?(user)
  end

  def remove_products?
    wishlist and  wishlist.event.is_owner?(user)
  end

  def show?
    wishlist and  wishlist.event.is_owner?(user)
  end

  def show_wished_products?
    wishlist and wishlist.event.is_owner?(user)
  end

  def update_quantity?
    wishlist and wishlist.event.is_owner?(user)
  end

end