module EventsHelper

  def event_cover_photo(version,event)
    if event.event_photo
      image_tag event.event_photo.image_url(version)
    else # default
      image_tag 'event1.png',width: '100px',height: '90px'
    end
  end

end
