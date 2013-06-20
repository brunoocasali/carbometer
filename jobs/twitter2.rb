require 'twitter'

credentials_present =
  ENV['TWITTER_CONSUMER_KEY'] && ENV['TWITTER_CONSUMER_SECRET'] &&
  ENV['TWITTER_OAUTH_TOKEN'] && ENV['TWITTER_OAUTH_SECRET']

if credentials_present
  Twitter.configure do |config|
    config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
    config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
    config.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']
  end

  SCHEDULER.every '10m', :first_in => 0 do |job|
    tweets = ['carbonfive', '"Carbon Five"'].map do |query|
      Twitter.search(URI::encode(query)).results.map do |tweet|
        {
          name: tweet.user.name,
          body: tweet.text,
          avatar: tweet.user.profile_image_url_https(:thumbnail),
          date: tweet.created_at.strftime("%d %B %Y")
        }
      end
    end.flatten

    send_event('carbonfive-tweets2', tweets: tweets)
  end
else
  puts "-------------------------------------------------------------------------"
  puts " Twitter ENV vars were not found. Widget will be blank.                  "
  puts "-------------------------------------------------------------------------"
end