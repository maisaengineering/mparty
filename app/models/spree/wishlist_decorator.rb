Spree::Wishlist.class_eval do
	belongs_to :event
	validates :event_id, :uniqueness => true
  has_many :wished_products,dependent: :destroy


	has_many :wishlist_orders
	has_many :orders ,through:  :wishlist_orders
	# has_many :wished_products,through: :wishlist_orders,class_name: "Spree::WishedProduct"
	has_many :purchased_products,through: :wishlist_orders,source: :wished_product,class_name: "Spree::WishedProduct"


  def all_items_purchased?
    wished_products.sum("quantity_purchased")  >=  wished_products.sum("quantity")
  end

end