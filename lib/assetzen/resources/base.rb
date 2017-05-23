module AssetZen
  module Resources
    class Base < Hash
      def initialize(values = {}, client = nil)
        values.each do |k, v|
          send('[]=', k.to_sym, v)
        end

        @client = client
      end
    end
  end
end
