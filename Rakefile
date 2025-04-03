# frozen_string_literal: true

require "appraisal"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

CLEAN.include ".rspec_status", "coverage", "gemfiles"
RSpec::Core::RakeTask.new(:rspec)
RuboCop::RakeTask.new
