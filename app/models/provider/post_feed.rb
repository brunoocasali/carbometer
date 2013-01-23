class Provider::PostFeed
  WORDPRESS_API = 'https://public-api.wordpress.com/rest/v1/sites/blog.carbonfive.com'

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
    page_url = "#{WORDPRESS_API}/posts/"
    page_url = "#{page_url}?page=#{page_number}"
    response = HTTParty.get(page_url)

    posts = JSON(response.body)['posts']
    return nil if posts == []

    posts
  end

  def self.post(wordpress_id)
    post_url = "#{WORDPRESS_API}/posts/#{wordpress_id}"
    response = HTTParty.get(post_url)
    post = JSON(response.body)
  end
end
