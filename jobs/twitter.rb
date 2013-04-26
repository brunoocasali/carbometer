require 'typhoeus'
require 'json'
require 'cgi'


SCHEDULER.every '10m', :first_in => 0 do |job|
  tweets = []
  search_terms = ['carbonfive', 'Carbon Five']
  search_terms.each do |term|
    response = Typhoeus.get "search.twitter.com/search.json?q=%22#{URI::encode term}%22"
    JSON(response.body)["results"].each do |result|
      tweets << result
    end
  end
  if tweets
    tweets.uniq!
    tweets.map! do |tweet|
      tweet_body = CGI.unescapeHTML tweet['text']
      tweet_date = Date.parse(tweet['created_at']).strftime("%d %B %Y")
      { name: tweet['from_user'], body: tweet_body, avatar: tweet['profile_image_url_https'], date: tweet_date }
    end

    send_event('carbonfive-tweets', tweets: tweets)
  end
end
