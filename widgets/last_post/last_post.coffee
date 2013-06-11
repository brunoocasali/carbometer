class Dashing.LastPost extends Dashing.Widget
  onData: (data) ->
    console.log data
    days = data.published_at
    @set 'days', days
