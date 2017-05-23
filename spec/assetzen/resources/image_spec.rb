require 'spec_helper'

describe AssetZen::Resources::Image do
  describe '#signed_link' do
    before(:each) do
      @image = AssetZen::Resources::Image.new({
        id: 1234,
        sid: "abcdefghi",
        title: "Example"
      }, mock_client)
    end

    it 'returns a URI' do
      mock(:get, '/account')
      expect(@image.signed_link).to be_a URI
    end
  end

  describe '#unsigned_link' do

  end
end
