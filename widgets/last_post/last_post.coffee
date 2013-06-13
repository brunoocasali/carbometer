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
    counter.removeClass()

    if happiness
      counter.addClass 'happy'
      node.removeClass '-1', '-2', '-3', '-4', '-5', '-6', '-7', '-8'
      node.addClass "-#{daysSinceLastPost}"
    else
      node.addClass '-8'
      counter.addClass 'sad'
