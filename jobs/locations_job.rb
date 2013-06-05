require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host

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
