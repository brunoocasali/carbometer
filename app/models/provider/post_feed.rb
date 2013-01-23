class Provider::PostFeed

  def self.find_all
    feed_url = 'https://public-api.wordpress.com/rest/v1/sites/blog.carbonfive.com/posts/'
    response = HTTParty.get(feed_url)
    posts = JSON(response.body)['posts']
  end

end
