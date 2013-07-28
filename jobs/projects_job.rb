require 'typhoeus'

SCHEDULER.every '1m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  host = ENV['CARBOMETRICS_HOSTNAME'] || 'localhost:3000'

  response = Typhoeus.get "#{host}/projects.json", followlocation: true
  response_body = JSON response.body

  send_event('carbonfive-projects', { categories: response_body })
end
