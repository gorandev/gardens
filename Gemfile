source "http://rubygems.org"

gem 'rails', '3.2.6'
gem 'sqlite3'
gem 'pg'
gem 'formtastic', '~> 1.2.3'
gem 'rspec-http', '~> 0.0.1'
gem 'rabl', :git => 'https://github.com/nesquena/rabl.git'
gem 'settingslogic'
gem 'thin'
gem 'redis'
gem 'devise'
gem 'jammit-s3'
gem 's3_swf_upload', :git => 'git://github.com/nathancolgate/s3-swf-upload-plugin'
gem 'pony'

gem 'dynamic_form'
gem 'rails_log_stdout'

gem 'google-analytics-rails'

gem 'dalli'

# usamos Mongoid 2.0 porque la 3 requiere Ruby 1.9.3 -- y para eso hay que mudarse al Cedar Stack de Heroku
gem "mongoid", "~> 2.4"

# agregamos Mongo para ver si funciona más rápido sin el object mapping
gem "mongo", "~> 1.7.0"
gem "bson_ext", "~> 1.7.0"

group :development do
  gem 'rspec-rails'
  gem 'annotate'
end

group :test do
  gem 'rspec'
  gem 'webrat'
  gem 'factory_girl_rails'
end
