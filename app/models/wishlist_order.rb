# t.integer :order_id, null: false
# t.integer :wishlist_id, null: false
# t.integer :wished_product_id, null: false
# t.integer :quantity_purchased,null: false,default: 0
class WishlistOrder < ActiveRecord::Base

  belongs_to :order ,foreign_key: 'order_id',class_name: "Spree::Order"
  belongs_to :wishlist ,foreign_key: 'wishlist_id',class_name: "Spree::Wishlist"
  belongs_to :wished_product ,foreign_key: 'wished_product_id',class_name: "Spree::WishedProduct"

  validates :order_id,:event_id,:wishlist_id,:wished_product_id,presence: true

end
