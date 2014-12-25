json.array!(@events) do |event|
  json.extract! event, :id, :date, :place, :cost_total, :cost_per_person
  json.url event_url(event, format: :json)
end
