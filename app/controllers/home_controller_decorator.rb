Spree::HomeController.class_eval do
  skip_before_filter :auth_user

  def index
    if params[:query].present?
      events = Event.trending.search(params[:query])
      flash.now[:notice] = "Total #{ActionController::Base.helpers.pluralize(events.count,'result')} results found for your search"
    else
      events = Event.trending
    end
    @trending_events = events.page(params[:page]).per(8)
    render layout: false if request.xhr?
  end

end