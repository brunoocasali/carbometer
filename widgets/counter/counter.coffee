class Dashing.Counter extends Dashing.Widget
  @accessor 'updatedOnMessage', ->
    if updatedAt = @get('kitchen.updated_at')
      timestamp = new Date(updatedAt)
      "Updated on #{timestamp.toDateString()}"

  onData: (data) ->
    location_data = data[@location]
    @set 'kitchen', location_data.kitchen if location_data
