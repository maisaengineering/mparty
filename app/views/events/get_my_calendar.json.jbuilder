json.prettify!
json.array!(@events.uniq) do |event|
  json.extract! event, :id, :description
  json.title event.name
  json.start event.starts_at.iso8601
  json.end  event.ends_at.iso8601
  json.url event_url(event)
  if !event.is_owner?(current_spree_user)
    inv = event.invites.where(user_id: current_spree_user.id).first
    if inv.present?
      if inv.joined == 0
        json.color '#cccccc' # gray pending inv
        json.tooltip 'Pending Invitation'
      elsif inv.joined == 1
        json.color '#91e374' #green accepted/attending
        json.tooltip 'Attending Event'
      elsif inv.joined == 2
        json.color '#bc1339' # red rejected
        json.tooltip 'Rejected Invitation'
      elsif inv.joined == 3
        json.color '#fce17e' #yellow maybe
        json.tooltip 'May be Attending Event'
      end
    end
  else
    json.color '#13a7c7' # blue own event
    json.tooltip 'Your Event'
  end

  # if event.ends_at.hour - event.starts_at.hour >= 23
  #   json.allDay true
  # else
  #   json.allDay false
  # end
end