# frozen_string_literal: true

module Limitable
  # == Limitable::Base
  #
  # Module that allows for automatic inclusion of Limitable within subclasses when extended in a superclass.
  #
  module Base
    def inherited(klass)
      super
      klass.include Limitable
    end
  end
end
