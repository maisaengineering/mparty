json.prettify!
json.array!(@slots) do |slot|
  json.title slot.event.present? ? slot.event.name : 'Reserved'
  json.start slot.start_date.iso8601
  json.end slot.end_date.iso8601
  json.color slot.color
  json.status slot.status_str
  # json.color 'red'
  #json.overlap false
  #json.rendering 'background'
  #json.color '#ff9f89'

  if slot.end_date.hour - slot.start_date.hour >= 23
    json.allDay true
  else
    json.allDay false
  end
end