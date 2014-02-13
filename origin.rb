#
# This is the origin server for the marsupial.graphics service
#

require 'sinatra'
require 'socket'

set :bind, '0.0.0.0'
set :port, 80
disable :protection

# Get a list of the marsupials we have in stock
marsupials = Dir.glob('marsupials/*')

# Send a random marsupial
get '/' do
  headers \
    'Server' => 'Marsupial Origin',
    'X-Served-By' => Socket.gethostname,
    'Cache-Control' => 'no-cache',
    'Connection' => 'close'

  send_file marsupials.sample, last_modified: Time.now
end
