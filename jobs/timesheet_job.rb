require 'typhoeus'

SCHEDULER.every '1m', first_in: rand(20) do |job|
  puts "Running #{File.basename(__FILE__)}"

  api_token = ENV['TIMESHEET_API_TOKEN']
  timesheet_host = ENV['TIMESHEET_HOSTNAME'] || 'localhost:3333'
  timesheet_host = "https://#{timesheet_host}" unless timesheet_host.match /^localhost/

  if api_token.nil?
    response_body = { 'total_delinquent_hours' => '?' }
  else
    response = Typhoeus.get "#{timesheet_host}/api/status?api_token=#{api_token}", followlocation: true
    response_body = JSON response.body
  end

  send_event('timesheet-status', response_body)
end
