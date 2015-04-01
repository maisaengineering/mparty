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
    event.starts_at.try(:strftime, '%I-%M %p')
  end

  def event_address(event)
    #"#{event.location} #{event.city}"
    if event.venue
      "#{event.venue.name}"
    else
      "#{event.location} #{event.city}"
    end
  end

  def picture_image_tag(picture,version=nil)
    if picture.image_processing?
      height_width = []
      case version
        when :thumb
          height_width = [90,90]
        when :slide_show
          height_width =  picture.imageable_type.eql?('Event') ? [190, 190] : [195, 195]
        when :preview
          height_width =  picture.imageable_type.eql?('Event') ? [293,296] : [270,360]
      end
      image_tag picture.image.url ,height: height_width.first,width: height_width.last
    else
      image_tag picture.image.url(version)
    end

  end

  def move_custom_to_last(args = [])
    a = args.pluck(:name,:id)
    c = a.select{|x| x[0] == 'custom' || x[0] == 'Custom'}
    return last = (a-c) + c
  end

  def event_desc_count(desc = nil)
    event_desc = desc.squeeze(' ')
    length = event_desc.length
    count=0
    m=0
    for i in 0..length
      if((event_desc[i] != "\n") || (event_desc[i] == "\r"))
        count +=1
      elsif(event_desc[i] == "\n")
        count +=1
        m = m+1
        if(m >= 3)
          break
        end
      end
    end
    if( count < 120)
      return count + 3
    else
      return 115
    end
  end

end
