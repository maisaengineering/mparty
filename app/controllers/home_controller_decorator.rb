Spree::HomeController.class_eval do
  skip_before_filter :auth_user

end