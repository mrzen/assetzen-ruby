AssetZen Ruby
=============

[![Build Status](https://travis-ci.org/mrzen/assetzen-ruby.svg?branch=master)](https://travis-ci.org/mrzen/assetzen-ruby)
[![Coverage Status](https://coveralls.io/repos/github/mrzen/assetzen-ruby/badge.svg?branch=master)](https://coveralls.io/github/mrzen/assetzen-ruby?branch=master)

Official library for [AssetZen][az].

Installation
------------

### Using Bundler (recommended)

~~~~ruby
  gem 'assetzen'
~~~~

### Using gem

~~~~ruby
  gem install assetzen
~~~~

Usage
-----

You will need to [create an application](https://app.assetzen.net/oauth/applications/new)
in order to use the API. You will also need to get and store a user access grant
in order to make API calls. This is not handled by the library as it is specific
to the application, as you will need to provide a callback in your application to
redirect the user once they approve authorization, and a secure storage mechanism for
the granted tokens.

### Searching Images

~~~~ruby
require 'assetzen'

@client = AssetZen::API::Client.new do |config|
  config.credentials = some_method_to_get_credentials
end

images = @client.images(q: 'food')

~~~~

### Linking an image

~~~~ruby
  @client = some_method_to_get_client # see previous example
  image = @client.images(q: 'food').sample # Sample random match
  url = image.signed_link(width: 800, height: 600)

  image_tag href: url
~~~~

### Updating an Image

~~~~ruby
  @client = some_method_to_get_client # see first example
  image = @client.image('example') # get image with ID 'example'

  image.title = "My new image title"
  image.save
~~~~

[az]: http://assetzen.net/
