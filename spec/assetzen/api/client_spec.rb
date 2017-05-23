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

  describe '#class_for' do
    before(:all) do
      @client = mock_client
    end

    context 'when an invalid verb is given' do
      it 'raises an error' do
        expect{ @client.class_for('INVALID') }.to raise_error ArgumentError
      end
    end

    context 'when the method is \'GET\'' do
      it 'returns Net::HTTP::Get' do
        expect(@client.class_for 'GET').to eq Net::HTTP::Get
      end
    end

    context 'when the method is \'POST\'' do
      it 'returns Net::HTTP::Post' do
        expect(@client.class_for 'POST').to eq Net::HTTP::Post
      end
    end

    context 'when the method is \'PATCH\'' do
      it 'returns Net::HTTP::Patch' do
        expect(@client.class_for 'PATCH').to eq Net::HTTP::Patch
      end
    end

    context 'when the method is \'HEAD\'' do
      it 'returns Net::HTTP::Head' do
        expect(@client.class_for 'HEAD').to eq Net::HTTP::Head
      end
    end
  end
end
