Spree::HomeController.class_eval do
  skip_before_filter :auth_user

  def index
    @trending_events = Event.trending.page(params[:page]).per(4)
  end

end