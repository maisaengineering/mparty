Spree::HomeController.class_eval do
  skip_before_filter :auth_user

  def index
    # @trending_events = Event.where(is_private: false)
  end

end