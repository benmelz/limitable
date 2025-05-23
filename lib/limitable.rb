# frozen_string_literal: true

require "active_record"
require "i18n"
require_relative "limitable/base"
require_relative "limitable/locale"
require_relative "limitable/version"

# == Limitable
#
# Module that declares database limit validations when included in an ActiveRecord model class. Supports limit
# inferences on integer, string, text and binary columns.
#
module Limitable
  class << self
    def included(klass)
      safe_column_names(klass).each do |column_name|
        attach_limit_validator_if_needed klass, column_name
      end
    end

    private

    def safe_column_names(klass)
      klass.column_names
    rescue ActiveRecord::ActiveRecordError, ArgumentError
      []
    end

    def attach_limit_validator_if_needed(klass, column_name)
      column = klass.column_for_attribute column_name
      limit = column.sql_type_metadata.limit
      return if limit.blank?

      case column.type
      when :integer, :string, :text, :binary
        klass.validate(&send(:"build_#{column.type}_limit_validator", column_name, limit))
      end
    end

    def build_integer_limit_validator(column_name, limit)
      min, max = integer_limit_range limit
      lambda do
        value = begin
          self.class.type_for_attribute(column_name).serialize self[column_name]
        rescue ActiveModel::RangeError => e
          e.message.match(/(?<number>\d+) is out of range/)[:number].to_i
        end
        next unless value.is_a? Integer

        errors.add column_name, I18n.t("limitable.integer_limit_exceeded.lower", limit: min) if value < min
        errors.add column_name, I18n.t("limitable.integer_limit_exceeded.upper", limit: max) if value > max
      end
    end

    def build_string_limit_validator(column_name, limit)
      lambda do
        value = self.class.type_for_attribute(column_name).serialize self[column_name]
        next unless value.is_a?(String) && value.bytesize > limit

        errors.add column_name, I18n.t("limitable.string_limit_exceeded", limit: limit)
      end
    end

    def build_text_limit_validator(column_name, limit)
      lambda do
        value = self.class.type_for_attribute(column_name).serialize self[column_name]
        next unless value.is_a?(String) && value.bytesize > limit

        errors.add column_name, I18n.t("limitable.text_limit_exceeded", limit: limit)
      end
    end

    def build_binary_limit_validator(column_name, limit)
      lambda do
        value = self.class.type_for_attribute(column_name).serialize self[column_name]
        next unless value.is_a?(ActiveModel::Type::Binary::Data) && value.to_s.bytesize > limit

        errors.add column_name, I18n.t("limitable.binary_limit_exceeded", limit: limit)
      end
    end

    def integer_limit_range(limit)
      max = (1 << ((limit * 8) - 1)) - 1
      min = -max
      [min, max]
    end
  end
end
