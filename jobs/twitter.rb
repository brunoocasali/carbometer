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
      tweet_body = tweet['text']
      tweet_body.gsub!(/(.{1})(https?:\/\/[.\/\+=\w]+)([\s]?)/,"\\1<a href='\\2'>\\2</a>\\3")
      tweet_body.gsub!(/(^|\s+)(@)(\w+)/,"\\1<a href='//twitter.com/\\3'>\\2\\3</a>")
      tweet_body.gsub!(/(^|\s+)(#)(\w+)/,"\\1<a href='//twitter.com/search?q=%23\\3&src=hash'>\\2\\3</a>")

      tweet_date = Date.parse(tweet['created_at']).strftime("%d %B %Y")

      { name: tweet['from_user'], body: tweet_body, avatar: tweet['profile_image_url_https'], date: tweet_date }
    end

    send_event('carbonfive-tweets', tweets: tweets)
  end
end
