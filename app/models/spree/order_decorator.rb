Spree::Order.class_eval do
  #replace :delivery to any other state

  # As per current UI not need to delivery method
  remove_checkout_step :delivery
end