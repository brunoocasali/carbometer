require 'typhoeus'

SCHEDULER.every '2m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  host = ENV['CARBOMETRICS_HOSTNAME'] || 'localhost:3000'

  response = Typhoeus.get "#{host}/api/v1/galleries.json", followlocation: true
  galleries = JSON response.body

  galleries.each_with_index do |gallery, index|
    send_event("gallery-#{index+1}", gallery)
  end
end
