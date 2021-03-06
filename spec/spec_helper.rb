require 'webmock/rspec'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter]
)

SimpleCov.start do
  add_filter '/spec/'
end

require_relative '../lib/assetzen'

# Allow us to send coverage reports to coveralls.
WebMock.disable_net_connect!(:allow => 'coveralls.io')

def mock(method, path)
  stub_request(method, 'https://app.assetzen.net'+path).to_return(
    status: 200,
    body: mock_body(method, path),
    headers: {
      'Content-Type' => mock_content_type_for(path)
    }
  )
end

def mock_path(method, path)
  path += '.json' unless path =~ /\.[a-z]+$/
  File.expand_path("../mock/#{method.to_s.downcase}#{path}", __FILE__)
end

def mock_body(method, path)
  File.read(mock_path(method, path))
end

def mock_content_type_for(path)
  'application/json'
end

def mock_client
  c = AssetZen::API::Client.new
  c.credentials = AssetZen::API::Credentials.new
  c.credentials.app_id = 1
  c.credentials.app_secret = 1
  c.credentials.auth_code = 1
  c.logger = Logger.new(STDOUT)
  c
end
