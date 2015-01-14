class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  helper_method :register_handlebars, :event_data_points

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def auth_user
    redirect_to spree_login_path unless signed_in?
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
    start_time = (event and !event.start_time.nil?) ? event.start_time.try(:strftime, '%I-%M %p') : nil
    data_points.merge!({eventTime: "#{start_at.try(:strftime, '%Y-%m-%d')} #{start_time}"})
    data_points.merge!({eventHostName:  event.host_name }) if event and !event.host_name.nil?
    data_points.merge!({eventDescription: event.description}) if event and !event.description.nil?
    data_points.merge!({eventCustomType: event.custom_event_type}) if event and !event.custom_event_type.nil?
    return data_points
  end
end
