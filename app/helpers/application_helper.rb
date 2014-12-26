module ApplicationHelper

  #alias_method :current_user, Spree::AuthenticationHelpers::spree_current_user
  
  def current_user
   current_spree_user
  end
    
  def title
    controller = params[:controller]
    case controller
      when 'events'
        "Events Management"
      when 'invites'
        "Invitation Management"
      else
        "Mparty Event Management"
    end
  end

  def store_menu?
    if params[:controller] == 'events' || params[:controller] == 'invites'
      false
    end
  end

  def try_spree_current_user
    if current_spree_user.present?
      current_spree_user
    else
      false
    end
  end

  def bootstrap_class_for(flash_type)
    {
        success: 'alert-success',# Green
        error: 'alert-danger',# Red
        alert: 'alert-warning',# Yellow
        notice: 'alert-info' # Blue
    }[flash_type.to_sym] || flash_type.to_s

  end

  def date_formatter(date)
    date.strftime('%d-%m-%Y %H:%M:%S') if date
  end

  def cover_photo(imageable,version=nil)
    if imageable.cover_photo
      image_tag imageable.cover_photo.image_url(version)
    else # default
      if imageable.is_a?(Event)
        image_tag 'event1.png',width: '100px',height: '90px'
      else
        image_tag 'venue-sample.jpg'
      end
    end
  end



  def event_data_points(event=nil,template=nil)
    data_points = {}
    data_points.merge!({templateName: template.name }) if template
    data_points.merge!({eventName: event.name }) if event and !event.name.nil?
    start_at = (event and !event.starts_at.nil?) ? event.starts_at : Time.now
    data_points.merge!({eventTime: start_at.try(:strftime, '%Y-%m-%d') })
    data_points.merge!({eventHostName:  event.host_name }) if event and !event.host_name.nil?
    data_points.merge!({eventDescription: event.description}) if event and !event.description.nil?
    return data_points
  end

end
