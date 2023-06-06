# frozen_string_literal: true

require 'active_record'
require 'i18n'
require_relative 'limitable/base'
require_relative 'limitable/version'

# == Limitable
#
# Module that declares database limit validations when included in an ActiveRecord model class. Supports limit
# inferences on integer, string and text columns.
#
module Limitable
  class << self
    def included(klass)
      safe_column_names(klass)&.each do |column_name|
        add_limit_validation klass, column_name
      end
    end

    private

    def safe_column_names(klass)
      klass.column_names
    rescue ActiveRecord::ActiveRecordError, ArgumentError
      nil
    end

    def add_limit_validation(klass, column_name)
      column = klass.column_for_attribute column_name
      limit = column.sql_type_metadata.limit
      return if limit.blank?

      case column.type
      when :integer
        add_integer_limit_validation klass, column_name, limit
      when :string, :text
        add_string_limit_validation klass, column_name, limit
      end
    end

    def add_integer_limit_validation(klass, column_name, limit)
      min, max = integer_limit_range limit
      integer_type_normalizer = method :integer_type_normalizer
      klass.validate do
        value = integer_type_normalizer.call klass, column_name, self[column_name]
        next unless value.is_a?(Integer)

        errors.add column_name, I18n.t('errors.messages.greater_than_or_equal_to', count: min) if value < min
        errors.add column_name, I18n.t('errors.messages.less_than_or_equal_to', count: max) if value > max
      end
    end

    def integer_limit_range(limit)
      max = (1 << ((limit * 8) - 1)) - 1
      min = -max
      [min, max]
    end

    def integer_type_normalizer(klass, column_name, value)
      klass.type_for_attribute(column_name).serialize value
    rescue ActiveModel::RangeError => e
      e.message.match(/(?<number>\d+) is out of range/)[:number].to_i
    end

    def add_string_limit_validation(klass, column_name, limit)
      klass.validate do
        value = klass.type_for_attribute(column_name).serialize self[column_name]
        next unless value.is_a?(String) && value.bytesize > limit

        errors.add column_name, I18n.t('errors.messages.too_long.other', count: limit)
      end
    end
  end
end
