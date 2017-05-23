require 'base64'

module AssetZen
  module Resources
    ##
    # Image Resource
    #
    # Represents a single image from the library
    class Image < Base
      ##
      # Save the image
      def save
        if self[:id]
          return upload_sync(self[:source]) unless self[:source].nil?
          resp = @client.patch('/images/' + self[:sid], self)
        else
          resp = @client.put('/images', self)
        end

        # Merge saved data with our data
        data = JSON.load(resp.body)
        merge! self.class.new(data)

        self
      end

      ##
      # Upload an image
      #
      # Example:
      #
      #    @client = some_method_to_get_client
      #    @image  = AssetZen::Resources::Image.new({
      #      title: "My New Image"
      #    })
      #    @image.upload_sync(File.open('./file.jpg'))
      #
      #
      # @param [UploadIO] source Image file source
      # @return [AssetZen::Resources::Image] Uploaded & Saved Image
      def upload_sync(source)
        unless source.is_a?(UploadIO)
          raise ArgumentError, "Source must be an UploadIO, not #{source.class.name}"
        end

        params = dup
        params[:file] = source

        uri = URI(AssetZen::API::Client::BASE_URL)
        uri.path = '/images'

        req = Net::HTTP::Put::Multipart.new(uri, params)

        res = @client.perform_request req
        res.value

        merge!(JSON.parse(res.body))
      end

      alias upload upload_sync

      ##
      # Get a signed link to the image
      #
      # Returns a signed URL to the image with the given parameters.
      #
      # @param [Hash] params Image parameters
      # @param [String] host Image Host
      #
      # @return [URI] Image link
      def signed_link(params = {}, host = nil)
        account = @client.account

        url = URI(host || account[:settings]['images_service'])
        url.path = '/image/' + self[:sid] + '/'

        params = params.to_json
        url_params = Base64.urlsafe_encode64(params).delete('=')

        url.path += sign_params(params, account[:id]) + '.' + url_params

        url
      end

      alias link signed_link

      private

      def sign_params(params, key)
        digest = OpenSSL::Digest.new('sha256')
        signature = OpenSSL::HMAC.digest(digest, key, params)

        Base64.urlsafe_encode64(signature).delete('=')
      end
    end
  end
end
