describe 'Carbometer.View.PostRow', ->
  beforeEach ->

    setFixtures """
      <div class='post-row' data-permalink=#{@pageUrl}>
        <li class='tweets'></li>
      </div>
    """

    @post = new Carbometer.Model.Post
      title: 'TestTitle',
      author_name: 'Mr Mister',
      published_at: '10/14/12',
      path: 'hey-now-the-path',
      visit_sum: '1000'

    @postUrl = 'http://blog.carbonfive.com'+@post.get('path')

    @view = new Carbometer.View.PostRow
      post: @post

  describe '#initialize', ->
    it 'creates a tweet count for the post', ->
      expect(@view.tweetCount).toBeDefined()
      expect(@view.tweetCount.get('pageUrl')).toEqual(@postUrl)

  describe '#render', ->
    beforeEach ->
      spyOn(@view, 'gravatarURL').andReturn('http://fake.gravatar.com')
      @view.render()
      @viewContent = $(@view.el).html()

    it 'renders the post title', ->
      expect(@viewContent).toContain(@post.get('title'))

    it 'renders the post date', ->
      expect(@viewContent).toContain(@post.get('published_at'))

    it 'renders the post author', ->
      expect(@viewContent).toContain(@post.get('author_name'))

    it 'renders the author avatar', ->
      expect(@viewContent).toContain('http://fake.gravatar.com')

  describe '#authorEmail', ->
    describe 'given an author name', ->
      beforeEach ->
        @authorName = 'Rob Pak'

      it 'returns the email address for the author', ->
        @view.authorName = 'Rob Pak'
        expect(@view.authorEmail()).toEqual('Rob@carbonfive.com')

  describe '#renderTweetCount', ->
    beforeEach ->
      @view.render()
      @count = 9
      @view.tweetCount.set count: @count

    it 'updates the tweet count', ->
      expect(@view.$('.tweets')).toHaveText("#{@count}")
