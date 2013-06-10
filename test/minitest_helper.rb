ENV["RAILS_ENV"] = "test"
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

require "vcr"
require "database_cleaner"
require "webmock/minitest"

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/the_buzziest_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
end


DatabaseCleaner.strategy = :truncation 

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  before :each do
    DatabaseCleaner.clean
  end
end

Sunspot.remove_all!
Sunspot.commit

Turn.config.format = :cue
# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  # fixtures :all

  def read_fixture(file='tasting_table_email.json')
    File.read(File.join('test', 'fixtures', file))
  end
end
