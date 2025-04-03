# frozen_string_literal: true

ruby_version = Gem::Version.new(RUBY_VERSION)

if ruby_version >= Gem::Version.new("2.5.0")
  appraise "rails-6.0" do
    gem "activerecord", "~> 6.0.0"
    if ruby_version >= Gem::Version.new("3.4.0")
      gem "base64"
      gem "bigdecimal"
      gem "mutex_m"
    end
  end

  appraise "rails-6.1" do
    gem "activerecord", "~> 6.1.0"
    if ruby_version >= Gem::Version.new("3.4.0")
      gem "base64"
      gem "bigdecimal"
      gem "mutex_m"
    end
  end
end

if ruby_version >= Gem::Version.new("2.7.0")
  appraise "rails-7.0" do
    gem "activerecord", "~> 7.0.0"
    if ruby_version >= Gem::Version.new("3.4.0")
      gem "base64"
      gem "bigdecimal"
      gem "mutex_m"
    end
  end

  appraise "rails-7.1" do
    gem "activerecord", "~> 7.1.0"
  end
end

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
