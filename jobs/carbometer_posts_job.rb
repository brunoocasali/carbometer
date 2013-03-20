require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  response = Typhoeus.get 'carbometer.herokuapp.com/posts.json', followlocation: true
  response_body = JSON response.body

  send_event('post-leaderboard', { posts: response_body })
end
