Spree::HomeController.class_eval do
  skip_before_filter :auth_user

  def index
    if Rails.env == "development"
      @city = "ALL"
    end

    if Rails.env == "production"    
      ip = request.remote_ip
      ip_info = GEOIP.city(ip)
      @city = ip_info.city_name if ip_info
    end

    available_cities = ['Hyderabad','Bangalore','Mumbai','Chennai']
    session[:current_city] = params[:user_city] if params[:user_city]

    @city = session[:current_city] if session[:current_city]
    if available_cities.include?(@city) and (@city != 'ALL')
      @trending_events = Event.includes(:pictures).upcoming.where(city: @city)
    else
     @city = "ALL"
     @trending_events = Event.upcoming
    end
    # @trending_events = Event.includes(:pictures).upcoming
    if params[:query].present?
      @trending_events = Event.includes(:pictures).upcoming.search(params[:query])
      flash.now[:notice] = "Total #{ActionController::Base.helpers.pluralize(@trending_events.count,'result')} results found for your search"
    end
    @trending_events = @trending_events.page(params[:page]).per(8)
    render layout: false if request.xhr?
  end
end