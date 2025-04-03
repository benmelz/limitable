# frozen_string_literal: true

require_relative "lib/limitable/version"

Gem::Specification.new do |spec|
  spec.name = "limitable"
  spec.summary = "Inferred database limit validations for ActiveRecord."
  spec.description = <<~DESCRIPTION.tr("\n", " ")
    Limitable scans your ActiveRecord database schema for column size limits and defines corresponding model validations
    so that you don't have to.
  DESCRIPTION
  spec.license = "MIT"
  spec.author = "Benjamin Melz"
  spec.email = ["ben@melz.me"]
  spec.homepage = "https://github.com/benmelz/limitable"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{Limitable::VERSION}/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*", "CHANGELOG.md", "README.md", "LICENSE.md"]
  spec.require_path = "lib"

  spec.version = Limitable::VERSION
  spec.required_ruby_version = ">= 3.0"
  spec.add_dependency "activerecord", ">= 6", "< 8.1"
  spec.add_dependency "i18n", ">= 1.6", "< 2"
end
