source 'https://rubygems.org'

gem 'rails', '3.2.3'

gem 'state_machine'
gem 'jquery-rails'
gem 'heroku'
gem 'thin'
gem 'airbrake'
gem 'slim'
gem 'kaminari'
gem 'omniauth-github', :git => 'git://github.com/intridea/omniauth-github.git'
gem 'omniauth-twitter'
gem 'redcarpet'
gem 'redis'
gem 'indextank'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'
gem 'twitter'
gem 'googl'

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'faker'
  gem 'guard-rspec'
  gem 'sqlite3'
  gem 'taps'
end

group :test do
  gem 'database_cleaner'
  gem 'rake', '0.9.2.2'
end

group :production do
  gem 'pg'
  # gem 'newrelic_rpm'
  gem 'dalli'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end