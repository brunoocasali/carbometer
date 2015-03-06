require 'typhoeus'

SCHEDULER.every '2m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  host = ENV['CARBOMETRICS_HOSTNAME'] || 'localhost:3000'

  response = Typhoeus.get "#{host}/instagrams.json", followlocation: true
  images = JSON response.body

  images.each_with_index do |image, index|
    send_event("instagram-#{index+1}", { url: image['url'], username: image['username'] })
  end
end
