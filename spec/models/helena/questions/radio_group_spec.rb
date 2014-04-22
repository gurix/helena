require 'spec_helper'

describe Helena::Questions::RadioGroup do
  let!(:version) { create :version, survey: create(:survey) }

  let(:question_group) { build :question_group, version: version }

  it 'deserializes the hash' do
    question = create :radio_group_question, question_group: question_group, validation_rules: { a: 1, b: 2, c: 3 }

    expect(question.reload.validation_rules).to eq("a" => 1, "b" => 2, "c" => 3)
  end

  it 'validates uniquness of label preselection' do
    question = create :radio_group_question, question_group: question_group
    question.labels << build(:label, preselected: true)
    question.labels << build(:label, preselected: true)
    expect(question).not_to be_valid
  end

  it 'does not validates uniquness of label preselection for no preselection' do
    question = create :radio_group_question, question_group: question_group
    question.labels << build(:label, preselected: false)
    question.labels << build(:label, preselected: false)
    expect(question).to be_valid
  end

  it 'does not validates uniquness of label preselection for one preselection' do
    question = create :radio_group_question, question_group: question_group
    question.labels << build(:label, preselected: false)
    question.labels << build(:label, preselected: false)
    expect(question).to be_valid
  end
end
