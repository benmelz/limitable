# frozen_string_literal: true

require "i18n"

module Limitable
  # == Limitable::Locale
  #
  # Loads the default limitable custom translations into i18n.
  #
  module Locale
    I18n.load_path << File.expand_path("locale/en.yml", __dir__)
  end
end
