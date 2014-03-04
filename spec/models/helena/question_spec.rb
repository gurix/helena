require 'spec_helper'

describe Helena::Question do
  it { expect(subject).to belong_to(:question_group) }
  it { expect(subject).to validate_presence_of(:question_group) }
  it { expect(subject).to validate_uniqueness_of(:code).scoped_to(:survey_id) }

  it 'has a valid factory' do
    expect(build :question).to be_valid
  end

  it 'deserializes the hash' do
    question = create :question, validation_rules: { a: 1, b: 2, c: 3 }

    expect(question.reload.validation_rules).to eq(a: 1, b: 2, c: 3)
  end
end
