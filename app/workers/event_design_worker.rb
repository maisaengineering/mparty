class EventDesignWorker
  include Sidekiq::Worker

  def perform(event_id)
    event = Event.find(event_id)
    handlebars = Handlebars::Context.new
    handlebars.register_helper(:ifEqual) do |context, v1,v2, block|
      v1===v2 ? block.fn(context) :  block.inverse(context)
    end

    template = Spree::Admin::Template.where(id: event.template_id).first
    event_design = template.designs.where(id: event.design_id).first if template
    c_design = handlebars.compile(event_design.content)
    file = Tempfile.new(["#{event.name}-#{Time.now.to_i}", '.jpg'], 'tmp', encoding: 'ascii-8bit')
    data_points = {}
    data_points.merge!({templateName: template.name }) if template
    data_points.merge!({eventName: event.name }) if event and !event.name.nil?
    start_at = (event and !event.starts_at.nil?) ? event.starts_at : Time.now
    end_at =   event ? event.ends_at : nil
    if event
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
    else
      event_time =  I18n.l(start_at)
      event_time +=  " - #{I18n.l(end_at)}" if end_at
    end
    data_points.merge!({eventTime: event_time})
    data_points.merge!({eventHostName:  event.host_name }) if event and !event.host_name.nil?
    data_points.merge!({eventDescription: event.description}) if event and !event.description.nil?
    data_points.merge!({eventCustomType: event.custom_event_type}) if event and !event.custom_event_type.nil?

    kit = IMGKit.new(c_design.call(MPARTY: data_points).html_safe, height: 660, width: 465, quality: 100)
    file.write(kit.to_png)
    file.flush
    event.fb_image = file
    event.save(validate: false)

  end
end
