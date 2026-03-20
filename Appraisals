# frozen_string_literal: true

ruby_version = Gem::Version.new(RUBY_VERSION)

if ruby_version >= Gem::Version.new("3.1.0")
  appraise "rails-7.2" do
    gem "activerecord", "~> 7.2.0"
  end
end

if ruby_version >= Gem::Version.new("3.2.0")
  appraise "rails-8.0" do
    gem "activerecord", "~> 8.0.0"
  end
end
