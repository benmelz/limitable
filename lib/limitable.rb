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
      safe_column_names(klass).each do |column_name|
        column = klass.column_for_attribute column_name
        limit = column.sql_type_metadata.limit
        next if limit.blank?

        case column.type
        when :integer
          klass.validate(&build_integer_limit_validator(column_name, limit))
        when :string, :text
          klass.validate(&build_string_limit_validator(column_name, limit))
        end
      end
    end

    private

    def safe_column_names(klass)
      klass.column_names
    rescue ActiveRecord::ActiveRecordError, ArgumentError
      []
    end

    def build_integer_limit_validator(column_name, limit)
      max = (1 << ((limit * 8) - 1)) - 1
      min = -max
      lambda do
        value = begin
          self.class.type_for_attribute(column_name).serialize self[column_name]
        rescue ActiveModel::RangeError => e
          e.message.match(/(?<number>\d+) is out of range/)[:number].to_i
        end
        next unless value.is_a?(Integer)

        errors.add column_name, I18n.t('errors.messages.greater_than_or_equal_to', count: min) if value < min
        errors.add column_name, I18n.t('errors.messages.less_than_or_equal_to', count: max) if value > max
      end
    end

    def build_string_limit_validator(column_name, limit)
      lambda do
        value = self.class.type_for_attribute(column_name).serialize self[column_name]
        next unless value.is_a?(String) && value.bytesize > limit

        errors.add column_name, I18n.t('errors.messages.too_long.other', count: limit)
      end
    end
  end
end
