require 'typhoeus'

SCHEDULER.every '1m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  host = ENV['CARBOMETRICS_HOSTNAME'] || 'localhost:3000'

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
