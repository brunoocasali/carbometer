require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => '10s' do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host
  response = Typhoeus.get "#{host}/posts/recent.json?limit=3", followlocation: true
  response_body = JSON response.body
  send_event('recent-posts', { posts: response_body })
end
