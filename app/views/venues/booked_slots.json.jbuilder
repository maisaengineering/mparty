json.prettify!
json.array!(@slots) do |slot|
  json.title 'Occupied'
  json.start slot.start_date
  json.overlap false
end