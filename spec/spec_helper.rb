require_relative '../lib/assetzen'
require 'webmock/rspec'


def mock(method, path)
  stub_request(method, 'https://app.assetzen.net'+path).to_return(
    status: 200,
    body: mock_body(method, path),
    headers: {
      'Content-Type': mock_content_type_for(path)
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
  c.logger = Logger.new('/dev/null')
  c
end
