module EventsHelper

  def event_cover_photo_url(event,version=nil)
    if event.event_photo
     event.event_photo.image_url(version)
    else # default
      asset_path('event_3.jpg')
    end
  end

  def event_cover_photo(event,version=nil)
    image_tag(event_cover_photo_url(event,version))
  end

  def event_start_date(event)
    event.try(:starts_at) and event.starts_at.to_date.eql?(Date.today)  ? 'Today' : event.starts_at.try(:strftime, '%d/%m/%Y')
  end

  def event_start_time(event)
    event.start_time.try(:strftime, '%I-%M %p')
  end

  def event_address(event)
    #"#{event.location} #{event.city}"
    if event.venue
      "#{event.venue.name}"
    else
      "#{event.location} #{event.city}"
    end
  end

end
