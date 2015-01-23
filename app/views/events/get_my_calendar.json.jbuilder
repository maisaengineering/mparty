json.prettify!
json.array!(@events) do |event|
  json.extract! event, :id, :description
  json.title event.name
  json.start event.starts_at
  json.end event.ends_at
  json.url event_url(event, format: :html)
  if !event.is_owner?(current_spree_user)
    inv = event.invites.where(user_id: current_spree_user.id).first
    if inv.present?
      if inv.joined == 0
         json.color '#555'
      elsif inv.joined == 1
         json.color '#8BD92F'
      elsif inv.joined == 2
         json.color '#d50e12'
      elsif inv.joined == 3
         json.color '#F0AD4E'
      end
    end
  end  
end