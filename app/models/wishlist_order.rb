class WishlistOrder < ActiveRecord::Base

 belongs_to :order ,foreign_key: 'order_id',class_name: "Spree::Order"
 belongs_to :event
 belongs_to :wishlist ,foreign_key: 'wishlist_id',class_name: "Spree::Wishlist"
 belongs_to :wished_product ,foreign_key: 'wished_product_id',class_name: "Spree::WishedProduct"

end
