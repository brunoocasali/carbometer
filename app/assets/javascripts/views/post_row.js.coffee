class Carbometer.View.PostRow extends Backbone.View
  className: 'post-row'
  template: _.template("
      <div class='avatar-col'>
        <p class='post-info'>+</p>
        <div class='avatar'></div>
      </div>
      <div class='title-info-col'>
        <h2 class='post-title'><%= post.title %></h2>
        <p class='post-author-date'>
          Posted on <strong><%= post.published_at %></strong> by <strong class='post-author-name'><%= post.author_name %></strong>
        </p>
      </div>
      <div class='statistics-col'>
        <ul class='counter'>
          <li class='views'><%= post.visit_sum %></li>
          <li class='tweets'>0</li>
        </ul>
      </div>
    ")

  initialize: (attributes) ->
    @post = attributes['post']
    pageUrl = "http://blog.carbonfive.com" + @post.get('path')
    @tweetCount = new Carbometer.Model.TweetCount pageUrl: pageUrl
    @tweetCount.on 'change:count', @renderTweetCount, @

  render: ->
    @authorName = @$('.post-author-name').text()
    @avatar = @$('.avatar')
    @renderAvatar()
    $(@el).html @template
      post: @post.attributes

  renderAvatar: ->
    avatarURL = @gravatarURL(@authorEmail())
    @avatar.css 'background-image', "url(#{avatarURL})"

  authorEmail: ->
    firstName = @authorName.split(' ')[0]
    "#{firstName}@carbonfive.com"

  gravatarURL: (email) ->
    Gravtastic email

  renderTweetCount: ->
    @$('.tweets').text("#{@tweetCount.get('count')}")
