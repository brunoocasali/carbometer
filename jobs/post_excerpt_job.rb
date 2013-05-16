require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host
  response = Typhoeus.get "#{host}/posts/excerpt.json", followlocation: true
  post = JSON response.body

  send_event('blog-excerpt', {
    post_title: post['title'],
    post_path: post['path'],
    post_excerpt: post['excerpt'],
    post_author: post['author_name'],
    post_visits: post['visit_sum'],
    post_comments: post['comment_count'],
    post_tweets: post['tweet_count']
  })
end
