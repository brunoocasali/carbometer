class Provider::PostTweets
  def self.get_tweets_for_path(path)
    post_url = "http://blog.carbonfive.com#{path}"
    twitter_response = HTTParty.get "http://urls.api.twitter.com/1/urls/count.json?url=#{post_url}&callback="
    twitter_response = JSON twitter_response.body
    twitter_response['count']
  end
end
