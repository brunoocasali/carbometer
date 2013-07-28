require 'twitter'

Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

SCHEDULER.every '10m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  tweets = ['carbonfive', '"Carbon Five"'].map { |query|
    Twitter.search(URI::encode(query)).results.map do |tweet|
      {
        name: tweet.user.name,
        handle: tweet.user.screen_name,
        body: tweet.text,
        avatar: tweet.user.profile_image_url_https(:thumbnail),
        date: tweet.created_at.strftime("%d %B %Y")
      }
    end
  }.flatten

  send_event('carbonfive-tweets', tweets: tweets)
end
