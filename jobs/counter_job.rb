require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host
  response = Typhoeus.get "#{host}/api/v1/foods/counter.json", followlocation: true
  response_body = JSON response.body

  send_event('carbonfive-counter', { kitchen: response_body })
end
