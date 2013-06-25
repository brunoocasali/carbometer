class Dashing.Tweets extends Dashing.Widget

  @accessor 'quote', ->
    "#{@get('current_tweet')?.body}"

  ready: ->
    @currentIndex = 0
    @tweetElem = $(@node).find('.tweet-info')
    @nextTweet()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextTweet, 8000)

  nextTweet: =>
    tweets = @get('tweets')
    if tweets
      @tweetElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % tweets.length
        @set 'current_tweet', tweets[@currentIndex]
        @tweetElem.fadeIn()
