require 'spec_helper'

describe Helena::Questions::CheckboxGroup do
  let!(:version) { build :version, survey: build(:survey) }

  let(:question_group) { build :question_group, version: version }

  it 'has a valid factory' do
    expect(build :checkbox_group_question, question_group: question_group).to be_valid
  end

  it 'indicates that it includes sub_questions' do
    question = build :checkbox_group_question, question_group: question_group

    expect(question.includes_subquestions?).to eq true
  end
end
