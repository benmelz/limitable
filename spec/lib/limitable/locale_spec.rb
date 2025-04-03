# frozen_string_literal: true

require "i18n"
require "limitable/locale"

RSpec.describe Limitable::Locale do
  it "defines a translation for integers that exceed an upper limit" do
    expect { I18n.t! "limitable.integer_limit_exceeded.upper" }.not_to raise_error
  end

  it "defines a translation for integers that exceed a lower limit" do
    expect { I18n.t! "limitable.integer_limit_exceeded.lower" }.not_to raise_error
  end

  it "defines a translation for strings that exceed a length limit" do
    expect { I18n.t! "limitable.string_limit_exceeded" }.not_to raise_error
  end

  it "defines a translation for text that exceeds a length limit" do
    expect { I18n.t! "limitable.text_limit_exceeded" }.not_to raise_error
  end

  it "defines a translation for binary data that exceeds a size limit" do
    expect { I18n.t! "limitable.binary_limit_exceeded" }.not_to raise_error
  end
end
