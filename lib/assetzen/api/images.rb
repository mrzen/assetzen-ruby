module AssetZen
  module API
    module Images
      ##
      # Get images
      #
      # @return [Array[AssetZen::Resources::Image]] Matching images
      def images(q = {})
        get('/images', q) do |resp|
          resp.value
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
        resp = get('/images/' + id)
        resp.value
        AssetZen::Resources::Image.new(JSON.parse(resp.body), dup)
      end
    end
  end
end
