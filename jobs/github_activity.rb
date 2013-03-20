require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '60m', :first_in => 0 do |job|
  response = Typhoeus.get 'carbometer.herokuapp.com/contributions.json', followlocation: true

  contributions = JSON response.body

  send_event('oss-update', oss_contributions: contributions)
end
