Spree::HomeController.class_eval do
  skip_before_filter :auth_user

  def index
    @trending_events = Event.trending
    if params[:query].present?
      @trending_events = @trending_events.where(Event.arel_table[:name].matches("%#{params[:query]}%"))
      flash.now[:notice] = "Total #{ActionController::Base.helpers.pluralize(@trending_events.count,'result')} results found for your search"
    end
    @trending_events = @trending_events.page(params[:page]).per(8)
    render layout: false if request.xhr?
  end

end