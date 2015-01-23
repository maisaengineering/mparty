json.prettify!
json.array!(@slots) do |slot|
  if slot.event.present?
    json.title slot.event.name
  else  
    json.title "Occupied" 
  end  
  json.start slot.start_date.iso8601
  json.end slot.end_date.iso8601
  if slot.end_date.hour - slot.start_date.hour >= 23
    json.allDay true
  else
    json.allDay false
  end
end