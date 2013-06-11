class Dashing.LastPost extends Dashing.Widget
  onData: (data) =>
    @setLastPostStatistics data.post

  setLastPostStatistics: (post) =>
    DAY_MILLIS = 86400000
    today = new Date()
    publishedAt = new Date post.published_at
    difference = today.getTime() - publishedAt.getTime()
    daysSinceLastPost = parseInt(difference / DAY_MILLIS)
    @set 'daysSinceLastPost', daysSinceLastPost

    @happiness daysSinceLastPost <= 7

  happiness: (happiness) =>
    node = $(@get 'node')
    counter = node.find '.counter'

    if happiness
      counter.removeClass 'sad'
      counter.addClass 'happy'
    else
      counter.removeClass 'happy'
      counter.addClass 'sad'
