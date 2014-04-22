require 'spec_helper'

describe Helena::Questions::ShortText do
  let!(:version) { create :version, survey: create(:survey) }
  let(:question_group) { build :question_group, version: version }
  it 'deserializes the hash' do
    question = create :short_text_question, question_group: question_group, validation_rules: { a: 1, b: 2, c: 3 }

    expect(question.reload.validation_rules).to eq("a" => 1, "b" => 2, "c" => 3)
  end
end
