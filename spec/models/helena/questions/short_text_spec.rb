require 'spec_helper'

describe Helena::Questions::ShortText do
  it 'deserializes the hash' do
    question = create :short_text_question, validation_rules: { a: 1, b: 2, c: 3 }

    expect(question.reload.validation_rules).to eq(a: 1, b: 2, c: 3)
  end
end
