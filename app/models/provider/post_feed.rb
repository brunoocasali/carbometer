class Provider::PostFeed

  def self.find_all
    current_page = 1
    feed = nil

    while response = page(current_page)
      current_page += 1

      if feed
        feed.entries << response
      else
        feed = response
      end
    end

    feed.entries.flatten
  end

  def self.page(page_number = 1)
    feed_url = 'https://public-api.wordpress.com/rest/v1/sites/blog.carbonfive.com/posts/'
    feed_url = "#{feed_url}?page=#{page_number}"
    response = HTTParty.get(feed_url)

    posts = JSON(response.body)['posts']
    return nil if posts == []

    posts
  end
end
