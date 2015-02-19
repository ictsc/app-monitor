require 'net/http'
require 'rufus-scheduler'

def print_status(now, url, status, status_code = '', response_time = '')
  puts "#{now}\t#{url}\t#{status}\t#{status_code}\t#{response_time}"
end

def monitor(url)
  begin
    start_time = Time.now
    response = Net::HTTP.get_response(URI.parse(url))
    time = Time.now - start_time
    status = response.code == '200' ? 'UP' : 'DOWN'
    print_status(start_time, url, status, response.code, time)
  rescue
    print_status(start_time, url, 'DOWN')
  end
end

unless ARGV[0]
  puts "usage: monitor [url]"
  exit
end

url = ARGV[0]
scheduler = Rufus::Scheduler.new

scheduler.every '1s' do
  monitor url
end

scheduler.join
