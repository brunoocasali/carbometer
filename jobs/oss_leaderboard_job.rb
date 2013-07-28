require 'typhoeus'

SCHEDULER.every '1m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  host = ENV['CARBOMETRICS_HOSTNAME'] || 'localhost:3000'

  response = Typhoeus.get "#{host}/api/v1/contributions.json", followlocation: true
  contributions = JSON response.body
  contributions = contributions.slice(0, 10)

  send_event('oss-leaderboard', items: contributions)
end
