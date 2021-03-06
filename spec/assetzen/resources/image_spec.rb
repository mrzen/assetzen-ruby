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

  describe '#upload' do
    before(:each) do
      @image = AssetZen::Resources::Image.new({
        title: "Example Image"
        }, mock_client)
    end

    context 'without a valid source' do
      it 'raises an error' do
        expect{@image.upload_sync("foo")}.to raise_error ArgumentError
      end
    end

    context 'with a valid source' do
      before(:each) do
        stub_request(:put, 'https://app.assetzen.net/images').with(
          :headers => {
            'Content-Type' => /^multipart\/form-data; boundary=/
          }
        ).to_return(
          :headers => {
            'Content-Type' => 'application/json',
          },
          'body' => mock_body(:put, '/images')
        )
      end
      it 'performs a multipart post' do
        @image.upload_sync(UploadIO.new(StringIO.new, "image/jpeg", "test.jpg"))
      end
    end
  end

  describe '#save' do
    context 'on a new image' do
      before(:each) do
        @image = AssetZen::Resources::Image.new({
          title: "Example Image",
          file_name: "example_image.jpg"
        }, mock_client)

        mock(:put, '/images')
      end

      it 'returns itself' do
        expect(@image.save).to be_an AssetZen::Resources::Image
      end

      it 'has an id' do
        @image.save
        expect(@image.id).not_to be_nil
      end
    end

    context 'on an existing image' do
      before(:each) do
        @image = AssetZen::Resources::Image.new({
          id: 12345,
          sid: "example",
          title: "Example Existing Image",
        }, mock_client)

        mock(:patch, '/images/example')
      end

      it 'returns itself' do
        expect(@image.save).to be_an AssetZen::Resources::Image
      end

      it 'is still the same image' do
        old_sid = @image.sid
        new_sid = @image.save.sid

        expect(new_sid).to eq old_sid
      end
    end
  end

end
