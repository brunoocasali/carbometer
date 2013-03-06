describe 'Carbometer.View.PostLeaderboard', ->
  beforeEach ->
    setFixtures "
      <div id='post-leaderboard'>
      </div>
    "
    @testPostCollection = new Carbometer.Collection.Posts

    @postInfo1 =
        {
          'title': 'TestTitle',
          'author_name': 'Mr Mister',
          'published_at': '10/14/12',
          'path': '/hey-now-the-path',
          'visit_sum': '1000'
          'comment_count': '10'
        }

    @postInfo2 =
      {
        'title': 'TestTitle2',
        'author_name': 'Mrs Mister',
        'published_at': '10/16/12',
        'path': '/hey-now-the-second-path',
        'visit_sum': '1500'
        'comment_count': '12'
      }

    spyOn(@testPostCollection,'fetch').andCallFake (params) ->
      params.success [@postInfo1, @postInfo2]

    @view = new Carbometer.View.PostLeaderboard
      collection: @testPostCollection

  describe '#render', ->
    beforeEach ->
      postRow1 = new Carbometer.View.PostRow
        post: new Carbometer.Model.Post @postInfo1

      postRow2 = new Carbometer.View.PostRow
        post: new Carbometer.Model.Post @postInfo2

      @view.postRows.push postRow1
      @view.postRows.push postRow2
      @view.render()

    it 'creates post row subviews', ->
      expect($(@view.el).children('.post-row').length).toEqual(2)

  describe '#add', ->
    beforeEach ->
      @view.render()
      post = new Carbometer.Model.Post @postInfo1

      @view.add(post)

    it 'creates post row subviews', ->
      expect(@view.postRows.length).toEqual(1)
