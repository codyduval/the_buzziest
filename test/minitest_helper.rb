ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "minitest/autorun"
require "vcr"
require "webmock/minitest"

VCR.configure.do |c|
  c.cassette_library_dir = 'test/fixtures/the_buzziest_cassettes'
  c.hook_into :webmock
end

Turn.config.format = :outline
