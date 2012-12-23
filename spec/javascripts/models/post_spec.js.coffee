describe 'Carbometer.View.PostLeaderboard', ->
  describe '#render', ->
    @post = new Carbometer.Model.Post
      title: 'TestTitle',
      author_name: 'Mr Mister',
      published_at: '10/14/12',
      path: '/hey-now-the-path',
      visit_sum: '1000'
