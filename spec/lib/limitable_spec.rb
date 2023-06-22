# frozen_string_literal: true

require 'limitable'
require 'i18n'
require 'support/active_record_shared_examples'

RSpec.describe Limitable do
  it 'has a version number' do
    expect(Limitable::VERSION).not_to be_nil
  end

  it 'defines a too large translation' do
    expect(I18n.t('errors.messages.too_large')).to be_present
  end

  context 'when mixed into a model' do
    include_context 'with an active record model'

    before { model.include described_class }

    context 'with an unsupported limited column' do
      let(:schema_builder) { ->(t) { t.float :limited_float_column, limit: 24 } }

      before { allow(model).to receive(:validate).and_call_original }

      it 'does not add any validators' do
        expect(model).not_to have_received(:validate)
      end
    end

    context 'with a limited integer column' do
      let(:schema_builder) { ->(t) { t.integer :limited_integer_column, limit: 2 } }

      it 'adds an upper limit validation in accordance with the column limit' do
        expect(model.new(limited_integer_column: 32_768)).not_to be_valid
      end

      it 'adds a lower limit validation in accordance with the column limit' do
        expect(model.new(limited_integer_column: -32_768)).not_to be_valid
      end

      it 'sets a locale error message when the upper limit is violated' do
        instance = model.new(limited_integer_column: 32_768).tap(&:validate)
        error_messages = instance.errors.messages[:limited_integer_column]
        expect(error_messages).to include(I18n.t('errors.messages.too_large'))
      end

      it 'sets a locale error message when the lower limit is violated' do
        instance = model.new(limited_integer_column: -32_768).tap(&:validate)
        error_messages = instance.errors.messages[:limited_integer_column]
        expect(error_messages).to include(I18n.t('errors.messages.too_large'))
      end

      it 'does not affect values just below the upper limit' do
        expect(model.new(limited_integer_column: 32_767)).to be_valid
      end

      it 'does not affect values just above the lower limit' do
        expect(model.new(limited_integer_column: -32_767)).to be_valid
      end

      it 'does not affect nil values' do
        expect(model.new(limited_integer_column: nil)).to be_valid
      end
    end

    context 'with an unlimited integer column' do
      let(:schema_builder) { ->(t) { t.integer :unlimited_integer_column } }

      before { allow(model).to receive(:validate).and_call_original }

      it 'does not add any validators' do
        expect(model).not_to have_received(:validate)
      end
    end

    context 'with a limited string column' do
      let(:schema_builder) { ->(t) { t.string :limited_string_column, limit: 5 } }

      it 'adds an length validation in accordance with the column limit' do
        expect(model.new(limited_string_column: 'abcd🖕')).not_to be_valid
      end

      it 'sets a locale error message when the limit is violated' do
        instance = model.new(limited_string_column: 'abcd🖕').tap(&:validate)
        error_messages = instance.errors.messages[:limited_string_column]
        expect(error_messages).to include(I18n.t('errors.messages.too_large'))
      end

      it 'does not affect values within the limit' do
        expect(model.new(limited_string_column: 'abcde')).to be_valid
      end

      it 'does not affect nil values' do
        expect(model.new(limited_string_column: nil)).to be_valid
      end
    end

    context 'with an unlimited string column' do
      let(:schema_builder) { ->(t) { t.string :unlimited_string_column } }

      before { allow(model).to receive(:validate).and_call_original }

      it 'does not add any validators' do
        expect(model).not_to have_received(:validate)
      end
    end

    context 'with a limited text column' do
      let(:schema_builder) { ->(t) { t.text :limited_text_column, limit: 5 } }

      it 'adds an length validation in accordance with the column limit' do
        expect(model.new(limited_text_column: 'abcd🖕')).not_to be_valid
      end

      it 'sets a locale error message when the limit is violated' do
        instance = model.new(limited_text_column: 'abcd🖕').tap(&:validate)
        error_messages = instance.errors.messages[:limited_text_column]
        expect(error_messages).to include(I18n.t('errors.messages.too_large'))
      end

      it 'does not affect values within the limit' do
        expect(model.new(limited_text_column: 'abcde')).to be_valid
      end

      it 'does not affect nil values' do
        expect(model.new(limited_text_column: nil)).to be_valid
      end
    end

    context 'with an unlimited text column' do
      let(:schema_builder) { ->(t) { t.text :unlimited_text_column } }

      before { allow(model).to receive(:validate).and_call_original }

      it 'does not add any validators' do
        expect(model).not_to have_received(:validate)
      end
    end

    context 'with a limited binary column' do
      let(:schema_builder) { ->(t) { t.binary :limited_binary_column, limit: 5 } }

      it 'adds an length validation in accordance with the column limit' do
        expect(model.new(limited_binary_column: 'abcd🖕')).not_to be_valid
      end

      it 'sets a locale error message when the limit is violated' do
        instance = model.new(limited_binary_column: 'abcd🖕').tap(&:validate)
        error_messages = instance.errors.messages[:limited_binary_column]
        expect(error_messages).to include(I18n.t('errors.messages.too_large'))
      end

      it 'does not affect values within the limit' do
        expect(model.new(limited_binary_column: 'abcde')).to be_valid
      end

      it 'does not affect nil values' do
        expect(model.new(limited_binary_column: nil)).to be_valid
      end
    end

    context 'with an unlimited binary column' do
      let(:schema_builder) { ->(t) { t.binary :unlimited_binary_column } }

      before { allow(model).to receive(:validate).and_call_original }

      it 'does not add any validators' do
        expect(model).not_to have_received(:validate)
      end
    end

    context 'with a limited custom type column' do
      let(:schema_builder) { ->(t) { t.integer :limited_enum_column, limit: 2 } }

      before do
        model.enum limited_enum_column: { good_value: 0, bad_value: 32_768 }
      end

      it 'adds an limit validation in accordance with the column limit' do
        expect(model.new(limited_enum_column: 'bad_value')).not_to be_valid
      end

      it 'sets a locale error message when the limit is violated' do
        instance = model.new(limited_enum_column: 'bad_value').tap(&:validate)
        error_messages = instance.errors.messages[:limited_enum_column]
        expect(error_messages).to include(I18n.t('errors.messages.too_large'))
      end

      it 'does not affect values within the limit' do
        expect(model.new(limited_enum_column: 'good_value')).to be_valid
      end

      it 'does not affect nil values' do
        expect(model.new(limited_enum_column: nil)).to be_valid
      end
    end
  end
end
