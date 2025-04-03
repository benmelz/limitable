# frozen_string_literal: true

require "logger"
require "active_record"
require "simplecov"

SimpleCov.start do
  add_filter %r{^/spec/}
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
