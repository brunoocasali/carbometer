require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '60m', :first_in => 0 do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host
  response = Typhoeus.get "#{host}/contributions.json", followlocation: true

  contributions = JSON response.body

  send_event('oss-update', oss_contributions: contributions)
  send_event('oss-leaderboard', items: contributions)
end
