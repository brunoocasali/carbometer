require 'typhoeus'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  host = ENV['CARBOMETRICS_HOSTNAME']
  host = 'localhost:3000' unless host
  response = Typhoeus.get "#{host}/instagrams.json", followlocation: true
  images = JSON response.body

  images.each_with_index do |image, index|
    send_event("instagram-#{index+1}", { url: image['url'], username: image['username'] })
  end
end
