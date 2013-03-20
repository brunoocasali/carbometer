require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  response = Typhoeus.get 'carbometer.herokuapp.com/posts/sources.json', followlocation: true
  response_body = JSON response.body

  send_event 'post-leaderboard-top-sources',
              items: response_body.map { |source| ['label' => source['source'], 'value' => source['visit_count']] }.flatten
end
