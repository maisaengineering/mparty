class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  helper_method :register_handlebars, :event_data_points

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def auth_user
    store_location
    if request.xhr?
      render js: "window.location = '/login'"  unless signed_in?
    else
      redirect_to spree_login_path unless signed_in?
    end
  end


  def pundit_user
    spree_current_user
  end

  def user_not_authorized(exception)
    #policy_name = exception.policy.class.to_s.underscore
    #flash[:error] = t('pundit.access_denied')
    # render file: "public/401.html", status: :unauthorized
    render 'shared/access_denied'
    #flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    #redirect_to(request.referrer || spree.root_path)
  end

  # Overriden from module Spree::Core::ControllerHelpers::Order because we are not using spree layout
  # Used in the link_to_cart helper.
  def simple_current_order
    @order ||= Spree::Order.find_by(id: session[:order_id], currency: current_currency)
  end

  def current_currency
    Spree::Config[:currency]
  end

  helper_method :simple_current_order,:current_currency


  def register_handlebars
    @handlebars = Handlebars::Context.new
    @handlebars.register_helper(:ifEqual) do |context, v1,v2, block|
      if v1===v2
        block.fn(context)
      else
        block.inverse(context)
      end
    end
  end

  def event_data_points(event=nil,template=nil)
    data_points = {}
    data_points.merge!({templateName: template.name }) if template
    data_points.merge!({eventName: event.name }) if event and !event.name.nil?
    start_at = (event and !event.starts_at.nil?) ? event.starts_at : Time.now
    end_at =   event ? event.ends_at : nil
    if I18n.l(start_at.to_date) == I18n.l(end_at.to_date)
      if I18n.l(start_at.to_date) == I18n.l(Date.today)
        event_time = "Today #{I18n.l start_at,format: :pick_time} - #{I18n.l end_at,format: :pick_time}"
      else
         event_time = "#{I18n.l start_at.to_date}  #{I18n.l start_at,format: :pick_time} - #{I18n.l end_at,format: :pick_time}"
      end
    else
      if I18n.l(start_at.to_date) == I18n.l(Date.today)
        event_time = "Today #{I18n.l start_at,format: :pick_time} - #{I18n.l end_at}"
      else
        event_time = " #{I18n.l start_at} - #{I18n.l end_at}"
      end
    end
    data_points.merge!({eventTime: event_time})
    data_points.merge!({eventHostName:  event.host_name }) if event and !event.host_name.nil?
    data_points.merge!({eventDescription: event.description}) if event and !event.description.nil?
    data_points.merge!({eventCustomType: event.custom_event_type}) if event and !event.custom_event_type.nil?
    return data_points
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.

    unless spree_current_user
      if (request.path != "/users/sign_in" &&
          request.path != "/users/sign_up" &&
          request.path != "/users/password/new" &&
          request.path != "/users/password/edit" &&
          request.path != "/users/confirmation" &&
          request.path != "/users/sign_out" &&
          !request.xhr?) # don't store ajax calls
        session[:spree_user_return_to] = request.fullpath
      end
    end

  end

  def after_sign_in_path_for(resource)
    session[:spree_user_return_to] || root_path
  end

end
