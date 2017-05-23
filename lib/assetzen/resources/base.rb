module AssetZen
  module Resources
    class Base < Hash
      def initialize(values = {}, client = nil)
        values.each do |k, v|
          send('[]=', k.to_sym, v)
        end

        @client = client
      end

      def method_missing(method, args = nil)
        if method =~ /\=$/
        else
          self[method]
        end
      end
    end
  end
end
