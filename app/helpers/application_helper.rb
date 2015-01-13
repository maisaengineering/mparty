module ApplicationHelper

  #alias_method :current_user, Spree::AuthenticationHelpers::spree_current_user
   YOUTUBE_FORMATS = [
    %r(https?://youtu\.be/(.+)),
    %r(https?://www\.youtube\.com/watch\?v=(.*?)(&|#|$)),
    %r(https?://www\.youtube\.com/embed/(.*?)(\?|$)),
    %r(https?://www\.youtube\.com/v/(.*?)(#|\?|$)),
    %r(https?://www\.youtube\.com/user/.*?#\w/\w/\w/\w/(.+)\b)
    ]
  
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
        image_tag 'venue_1.jpg'
      end
    end
  end


  def youtube_id(video_url)
    video_url.strip!
    YOUTUBE_FORMATS.find { |format| video_url =~ format } and $1
  end

end
