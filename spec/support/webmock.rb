
require 'webmock/rspec'

WebMock.allow_net_connect!(:net_http_connect_on_start => true)
