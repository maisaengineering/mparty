json.prettify!
json.array!(@events) do |event|
  json.title 'Occupied'
  json.start event.starts_at
  json.overlap false
end