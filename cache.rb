#
# This is a caching server for the marsupial.graphics service
#

require 'sinatra'
require 'socket'
require 'net/http'

set :bind, '0.0.0.0'
#set :port, 80
disable :protection

$cache_hits = 0


get '/' do
  marsupial = fetch_cache

  headers \
    'Server' => 'Marsupial Cache',
    'X-Served-By' => Socket.gethostname,
    'X-Cache' => $cache_hits > 1 ? 'HIT' : 'MISS'
    'X-Cache-Hits' => $cache_hits.to_s,
    'Connection' => 'close'

  marsupial
end


post '/cache' do
  refresh_cache!
end


delete '/cache' do
  clear_cache!
end


def fetch_cache
  if $cache
    $cache_hits += 1
  else
    refresh_cache!
  end

  $cache
end


def clear_cache!
  puts 'clearing cache'
  $cache = nil
  $cache_hits = 0
end


def refresh_cache!
  $cache = Net::HTTP.get('au.marsupial.graphics', '/')
  $cache_hits = 0
end
