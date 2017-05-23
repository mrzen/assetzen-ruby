require File.expand_path('../lib/assetzen/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'assetzen'
  gem.version = AssetZen::VERSION
  gem.date = '2017-05-22'
  gem.summary = 'Official Ruby Library for http://assetzen.net'
  gem.description = <<-DESC
  Official Ruby library for http://assetzen.net/
  Provides REST API client as well as helper libraries for generating
  and managing links.
DESC
  gem.authors = ['Leo Adamek']
  gem.email = 'info@mrzen.com'

  gem.extra_rdoc_files = ['README.md']

  gem.homepage = 'https://github.com/mrzen/assetzen-rb'

  gem.license = 'MIT'
  gem.files = Dir['lib/**/*.rb']

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_development_dependency('webmock', '> 0')
  gem.add_development_dependency('rdoc', '> 0')
  gem.add_development_dependency('rspec', '> 0')
  gem.add_development_dependency('yard', '> 0')
  gem.add_development_dependency('rubocop', '> 0')
  gem.add_development_dependency('pry', '> 0')
end
