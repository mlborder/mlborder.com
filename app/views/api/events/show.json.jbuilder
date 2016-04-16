json.(@event, :id, :name, :started_at, :ended_at, :event_type)
json.is_in_session @event.in_session?
if @border
  json.border @border[:borders]
  json.before_border @before_border
  json.border_updated_at @border[:time]
end
