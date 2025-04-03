# frozen_string_literal: true

require "limitable/base"

RSpec.describe Limitable::Base do
  context "when extended by a class that is then subclassed" do
    let!(:klass) do
      Class.new(ActiveRecord::Base) do
        extend Limitable::Base

        self.abstract_class = true
      end
    end
    let(:subklass) { Class.new(klass) { self.table_name = "fake_table" } }

    before { allow(Limitable).to receive(:included).and_call_original }

    it "mixes Limitable into the subclasses" do
      subklass
      expect(Limitable).to have_received(:included).with(subklass)
    end
  end
end
