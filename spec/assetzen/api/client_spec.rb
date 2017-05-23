require 'spec_helper'

describe AssetZen::API::Client do

  describe '#get' do
    before(:each) do
      @client = mock_client
    end

    it 'returns an HTTP Response type' do
      mock(:get, '/account')
      expect(@client.get('/account')).to be_a Net::HTTPOK
    end
  end


  describe '#account' do
    before(:each) do
      @client = mock_client
    end

    it 'returns an Account' do
      mock(:get, '/account')
      expect(@client.account).to be_an AssetZen::Resources::Account
    end
  end


  describe '#images' do
    before(:each) do
      @client = mock_client
    end

    it 'returns an array of Images' do
      mock(:get, '/images')
      images = @client.images
      expect(images).to be_an Array

      images.each do |image|
        expect(image).to be_an AssetZen::Resources::Image
      end
    end
  end


end
