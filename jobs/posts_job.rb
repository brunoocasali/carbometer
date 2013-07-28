require 'typhoeus'

SCHEDULER.every '1m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  host = ENV['CARBOMETRICS_HOSTNAME'] || 'localhost:3000'

  response = Typhoeus.get "#{host}/api/v1/posts/summary.json", followlocation: true
  summary = JSON response.body

  if summary.has_key?('last_post') && !summary['last_post'].empty?
    last_post = summary['last_post']
    send_event('blog-excerpt', {
      post_title:    last_post['title'],
      post_path:     last_post['path'],
      post_excerpt:  last_post['excerpt'],
      post_author:   last_post['author_name'],
      post_visits:   last_post['visit_sum'],
      post_comments: last_post['comment_count'],
      post_tweets:   last_post['tweet_count']
    })

    send_event('last-post', post: last_post)
  end

  recent_posts = summary['recent']
  send_event('recent-posts', { posts: recent_posts })

  popular_posts = summary['popular']
  send_event('post-leaderboard', { posts: popular_posts })
end
