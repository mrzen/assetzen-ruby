require 'oauth2'

module AssetZen
  module API
    ##
    # Credentials implements the OAuth2 credentials.
    class Credentials

      attr_accessor :app_id, :app_secret, :auth_code
      attr_reader :token_expires_at

      def initialize
      end

      ##
      # Gets a session token using the previously provided
      # app_id, app_secret and auth_code values.
      #
      # Generates a new token only if required
      #
      # @return [String] token
      def token
        @token ||= get_token

        refresh_token! if expired?

        @token
      end

      ##
      # Get a new Token
      #
      # @return [String] new token
      def get_token
        uri = URI(AssetZen::API::Client::BASE_URL)
        c = Net::HTTP.new(uri.host, uri.port)
        c.use_ssl = true
        c.set_debug_output Logger.new(STDOUT)

        headers = {
          'Accept' => 'application/json'
        }

        body = URI.encode_www_form({
          'grant_type' => 'authorization_code',
          'code' => @auth_code,
          'client_id' => @app_id
        })

        resp = c.post('/oauth/token', body)
        resp.value

        puts resp.body

        data = JSON.parse(resp.body)

        puts data

        return data
      end

      ##
      # Refreshes the current token
      #
      # @return [String] new token
      def refresh_token!
        uri = URI(AssetZen::API::Client::BASE_URL)
        Net::HTTP.new(uri.host, uri.port) do |http|
          http.use_ssl = true

          headers = {
            'Accept' => 'application/json'
          }

          body = URI.encode_www_form({
            :app_id => @app_id,
            :app_secret => @app_secret,
            :refresh_token => @refresh_token
          })
        end
      end

      ##
      # Check if the token is expired.
      #
      # @return [Bool] Token is expired?
      def expired?
        return false if @token_expires_at.nil?
        @token_expires_at < Time.now
      end
    end
  end
end
