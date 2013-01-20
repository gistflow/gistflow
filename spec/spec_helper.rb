ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include(Capybara::DSL, :type => :request)
  
  config.use_transactional_fixtures = false
  config.filter_run_excluding :remote => true
  # config.filter_run_excluding :local => true if ENV['TRAVIS']
  config.before(:suite) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) do
    DatabaseCleaner.clean
    config = YAML.load_file("#{Rails.root}/config/admins.yml")
    Rails.application.config.admins = config['usernames']
  end
  config.infer_base_class_for_anonymous_controllers = false
end