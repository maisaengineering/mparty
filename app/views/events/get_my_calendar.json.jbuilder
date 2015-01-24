json.prettify!
json.array!(@events) do |event|
  json.extract! event, :id, :description
  json.title event.name
  json.start event.starts_at.iso8601
  json.end event.ends_at.iso8601
  json.url event_url(event, format: :html)
  if !event.is_owner?(current_spree_user)
    inv = event.invites.where(user_id: current_spree_user.id).first
    if inv.present?
      if inv.joined == 0
         json.color '#555'
         json.tooltip 'Pending Invitation'
      elsif inv.joined == 1
         json.color '#8BD92F'
         json.tooltip 'Attending Event'
      elsif inv.joined == 2
         json.color '#d50e12'
         json.tooltip 'Rejected Invitation'
      elsif inv.joined == 3
         json.color '#F0AD4E'
         json.tooltip 'May be Attending Event'
      end
    end
  else
     json.color '#edb311'
     json.tooltip 'Your Event'  
  end
  if event.end_time - event.start_time >= 23
    json.allDay true
  else
    json.allDay false
  end  
end