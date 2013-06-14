require 'typhoeus'

SCHEDULER.every '1m', :first_in => '10s' do |job|
  api_token = ENV['TIMESHEET_API_TOKEN']
  timesheet_host = ENV['TIMESHEET_HOSTNAME']
  timesheet_host = 'localhost:3333' unless timesheet_host
  timesheet_host.prepend 'https://' unless timesheet_host.match /^localhost/

  if api_token.nil?
    response_body = { 'total_delinquent_hours' => '?' }
  else
    response = Typhoeus.get "#{timesheet_host}/api/status?api_token=#{api_token}", followlocation: true
    response_body = JSON response.body
  end

  send_event('timesheet-status', response_body)
end
