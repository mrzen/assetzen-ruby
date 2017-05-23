require 'net/http'
require 'logger'

module AssetZen
  module API
    ##
    # AssetZen API Client Class
    #
    # Provides a resourceful interface to interact with the AssetZen API
    #
    # Allows for low-level API interactions through the HTTP helper methods
    # (get, post, put, delete)
    #
    # Example:
    #
    #     api = AssetZen::API::Client.new
    #     api.credentials = method_to_get_api_credentials
    #     account = api.account
    #     images  = api.images(q: 'food')
    #     images.collect do |image|
    #        image.signed_link(width: 800, height: 600)
    #     end
    #
    class Client
      attr_writer :user_agent
      attr_writer :logger
      attr_accessor :credentials

      BASE_URL = 'https://app.assetzen.net/'.freeze

      ##
      # Create a new API Client
      def initialize
        @logger = Logger.new STDOUT

        base_uri = URI(BASE_URL)

        @connection = Net::HTTP.new(base_uri.host, base_uri.port)
        @connection.use_ssl = (base_uri.scheme == 'https')

        yield(self) if block_given?
      end

      ##
      # Get the user agent header value
      #
      # Defaults to the version of the Gem.
      #
      # @return [String] User-Agent header
      def user_agent
        @user_agent ||= "AssetZen Gem/#{AssetZen::VERSION}"
      end

      ##
      # Get the account details
      #
      # @return [AssetZen::Resources::Account] Account
      def account
        get('/account') do |resp|
          return AssetZen::Resources::Account.new(JSON.parse(resp.body), dup)
        end
      end

      ##
      # Get images
      #
      # @return [Array[AssetZen::Resources::Image]] Matching images
      def images(q = {})
        get('/images', q) do |resp|
          return JSON.parse(resp.body).collect do |image_data|
            AssetZen::Resources::Image.new(image_data, dup)
          end
        end
      end

      ##
      # Get an image by ID
      #
      # @param [String] id Image ID
      # @return [AssetZen::Resources::Image] Image
      def image(id)
        resp = get('/images/'+id)
        resp.value
        return AssetZen::Resources::Image.new(JSON.parse(resp.body), dup)
      end

      ##
      # Get runtime information.
      #
      # Added as a header (X-Runtime) to API requests to aid
      # vendor diagnostics
      #
      # @return [String] Runtime information
      def runtime_info
        "lang:\"ruby '#{RUBY_PLATFORM}'\"" \
          "version: \"v'#{RUBY_VERSION}p#{RUBY_PATCHLEVEL}'\"" \
          "lib: \"AssetZen Gem v#{AssetZen::VERSION}\" os: \"#{RUBY_PLATFORM}\""
      end

      ## Low-level Request methods

      ##
      # Perform a Request
      #
      # Performs an HTTP request yielding or returning the response
      #
      # @param [Symbol] method HTTP Method/Verb
      # @param [String] path   URL Path
      # @param [Any]    params Request parameters/payload.
      # @param [Hash]   headers Additional HTTP Headers
      #
      # @return [Net::HTTPResponse] HTTP Response
      def request(method, path, params = {}, headers = {})
        headers['User-Agent'] = user_agent
        headers['X-Runtime'] = runtime_info
        headers['Accept'] ||= 'application/json'

        uri = URI(BASE_URL)
        uri.path = path

        req_class = class_for(method)

        unless req_class.new('/').request_body_permitted?
          uri.query = URI.encode_www_form(params) unless params.empty?
        end

        req = req_class.new uri
        headers.each do |header, value|
          req[header] = value
        end

        if req.request_body_permitted?
          case params.class
          when Hash
            req.body = params.to_json
          when String
            req.body = params
          when IO
            req.body_stream = params
          end
        end

        resp = @connection.request req

        @logger.debug "#{method.to_s.upcase} #{uri} #{resp.code}"

        yield(resp) if block_given?

        resp
      end

      ##
      # HTTP Get Helper
      #
      # @see AssetZen::API::Client#request
      #
      # @return HTTPResponse
      def get(path, params = {}, headers = {})
        resp = request('GET', path, params, headers)

        yield(resp) if block_given?

        resp
      end

      ##
      # HTTP Put Helper
      #
      # @see AssetZen::API::Client#request
      #
      def put(path, params = {}, headers = {})
        resp = request('PUT', path, params, headers)

        yield(resp) if block_given?

        resp
      end

      ##
      # HTTP Patch Helper
      #
      # @see AssetZen::API::Client#request
      def patch(path, params = {}, headers = {})
        resp = request('PATCH', path, params, headers)

        yield(resp) if block_given?

        resp
      end

      ##
      # Get class for HTTP Request based on Method
      #
      # @param [String] method HTTP Method
      #
      # @return [Class] HTTP Request Class
      def class_for(method)
        case method
        when 'GET'
          Net::HTTP::Get
        when 'POST'
          Net::HTTP::Post
        when 'PUT'
          Net::HTTP::Put
        when 'PATCH'
          Net::HTTP::Patch
        when 'HEAD'
          Net::HTTP::Head
        else
          raise ArgumentError, "Invalid HTTP method #{method}"
        end
      end
    end
  end
end
