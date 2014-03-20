require 'spec_helper'

describe Helena::SubQuestion do
  let(:question_group) { create :question_group }
  let(:question) { create :question, question_group: question_group }

  it { expect(subject).to belong_to(:question) }
  it { expect(subject).to validate_presence_of(:question) }
  it { expect(subject).to validate_uniqueness_of(:code).scoped_to(:question_id) }
  it { expect(create :sub_question, question: question).to validate_uniqueness_of(:text).scoped_to(:question_id) }

  it 'has a valid factory' do
    expect(build :sub_question, question: question).to be_valid
  end
end
