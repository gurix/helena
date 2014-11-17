require 'spec_helper'

describe Helena::Question do
  let!(:version) { create :version, survey: create(:survey) }
  let(:question_group) { build :question_group, version: version }

  it { expect(subject).to belong_to(:question_group) }

  it { expect(subject).to validate_presence_of(:code) }

  it 'validates uniqness of code across different question_groups' do
    a_question = build :question, question_group: question_group, code: :preferred_color
    expect(a_question).to be_valid

    another_question = build :question, question_group: question_group, code: :preferred_color
    expect(another_question).not_to be_valid
  end

  it 'has a valid factory' do
    expect(build :question, question_group: question_group).to be_valid
  end

  it 'indicates that it does not include sub_questions or labels' do
    question = build :question, question_group: question_group

    expect(question.includes_subquestions?).to eq false
    expect(question.includes_labels?).to eq false
  end
end
