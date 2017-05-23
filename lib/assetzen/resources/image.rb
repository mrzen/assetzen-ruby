require 'base64'

module AssetZen
  module Resources
    ##
    # Image Resource
    #
    # Represents a single image from the library
    class Image < Base
      def signed_link(params = {}, host = nil)
        account = @client.account

        url = URI(host || account[:settings]['images_service'])
        url.path = '/image/' + self[:sid] + '/'

        params = params.to_json
        url_params = Base64.urlsafe_encode64(params, padding: false)

        url.path += sign_params(params, account[:id]) + '.' + url_params

        url
      end

      alias link signed_link

      private

      def sign_params(params, key)
        digest = OpenSSL::Digest.new('sha256')
        signature = OpenSSL::HMAC.digest(digest, key, params)

        Base64.urlsafe_encode64(signature, padding: false)
      end
    end
  end
end
