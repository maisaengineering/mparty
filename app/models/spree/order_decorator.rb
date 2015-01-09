Spree::Order.class_eval do
  #replace :delivery to any other state

  has_many :wishlist_orders
  # As per current UI not need to delivery method
  remove_checkout_step :delivery


end