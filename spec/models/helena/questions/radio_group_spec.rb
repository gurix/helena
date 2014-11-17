require 'spec_helper'

describe Helena::Questions::RadioGroup do
  let!(:version) { build :version, survey: build(:survey) }

  let(:question_group) { build :question_group, version: version }

  it 'has a valid factory' do
    expect(build :radio_group_question, question_group: question_group).to be_valid
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

  it 'indicates that it includes labels' do
    question = build :radio_group_question, question_group: question_group

    expect(question.includes_labels?).to eq true
  end
end
