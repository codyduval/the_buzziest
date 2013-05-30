ENV["RAILS_ENV"] = "test"
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require "minitest/autorun"
require "vcr"
require "database_cleaner"
require "webmock/minitest"

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/the_buzziest_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  end

def read_fixture(file='tasting_table_email.json')
    File.read(File.join('test', 'fixtures', file))
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

Turn.config.format = :cue
