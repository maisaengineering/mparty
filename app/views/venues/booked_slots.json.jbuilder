json.prettify!
json.array!(@slots) do |slot|
  json.title 'Occupied'
  json.start slot.start_date
  json.end slot.end_date
end