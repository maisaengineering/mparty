class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :register_handlebars, :event_data_points

  def auth_user
    redirect_to spree_login_path unless signed_in?
  end

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

  def event_data_points(event=nil,image_conversion = false)
    data_points = {}
    data_points.merge!({eventName: event.name }) if event
    data_points.merge!({eventTime: event.starts_at.try(:strftime, '%B %d, %Y') }) if event
    data_points.merge!({eventHost: "#{event.host_name} #{event.host_phone}"}) if event
    data_points.merge!({eventLocation: event.location }) if event
  end
end
