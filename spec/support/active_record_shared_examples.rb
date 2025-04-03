# frozen_string_literal: true

require "active_record"

RSpec.shared_context "with an active record model" do
  model_counter = 0

  let(:model_name) { "model#{model_counter += 1}" }
  let(:model_class_name) { model_name.to_s.singularize.classify }
  let(:model) { Class.new(ApplicationRecord) }

  let(:table_name) { model_name.to_s.pluralize.underscore }
  let(:schema_builder) { ->(_) {} }

  before do
    table_name = self.table_name
    schema_builder = self.schema_builder
    ActiveRecord::Schema.define { create_table(table_name, force: true, &schema_builder) }
    stub_const(model_class_name, model)
  end

  after do
    table_name = self.table_name
    ActiveRecord::Schema.define { drop_table(table_name) }
  end
end
