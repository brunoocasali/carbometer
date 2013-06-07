require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => '10s' do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host

  handle_recent_posts host
  handle_locations host
  handle_instagrams host
  handle_post_excerpts host
  handle_projects host
  handle_contributions host
end

def handle_recent_posts(host)
  response = Typhoeus.get "#{host}/posts/recent.json?limit=3", followlocation: true
  response_body = JSON response.body
  send_event('recent-posts', { posts: response_body })
end

def handle_locations(host)
  locations_data = {}
  locations = ['sf', 'la']
  locations.each do |location|
    response = Typhoeus.get "#{host}/api/v1/locations/#{location}/kitchens.json", followlocation: true
    response_body = JSON response.body
    locations_data[location] = {
      kitchen: response_body[0]
    }
  end

  send_event('carbonfive-fridge', locations_data)
  send_event('carbonfive-counter', locations_data)
end

def handle_instagrams(host)
  response = Typhoeus.get "#{host}/instagrams.json", followlocation: true
  images = JSON response.body

  images.each_with_index do |image, index|
    send_event("instagram-#{index+1}", { url: image['url'], username: image['username'] })
  end
end

def handle_post_excerpts(host)
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

def handle_projects(host)
  response = Typhoeus.get "#{host}/projects.json", followlocation: true
  response_body = JSON response.body

  send_event('carbonfive-projects', { categories: response_body })
end

def handle_contributions(host)
  response = Typhoeus.get "#{host}/api/v1/contributions.json", followlocation: true
  contributions = JSON response.body

  send_event('oss-leaderboard', items: contributions)
end
