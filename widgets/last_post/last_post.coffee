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

    @determineHappiness daysSinceLastPost

  determineHappiness: (daysSinceLastPost) =>
    happiness = (daysSinceLastPost <= 7)
    node = $(@get 'node')
    counter = node.find '.counter'
    counter.removeClass('.happy,.sad')

    if happiness
      counter.addClass 'happy'
      node.removeClass 'b-1', 'b-2', 'b-3', 'b-4', 'b-5', 'b-6', 'b-7', 'b-8'
      node.addClass "b-#{daysSinceLastPost}"
    else
      node.addClass 'b-8'
      counter.addClass 'sad'
