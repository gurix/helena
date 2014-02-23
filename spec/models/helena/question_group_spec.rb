require 'spec_helper'

describe Helena::QuestionGroup do

  it { expect(subject).to belong_to(:survey) }

  it 'has a valid factory' do
    expect(build :question_group).to be_valid
  end

  it 'sorts by default according the position' do
    last_question_group = create :question_group, position: 99
    first_question_group = create :question_group, position: 11

    expect(Helena::QuestionGroup.first).to eq first_question_group
    expect(Helena::QuestionGroup.last).to eq last_question_group
  end

end
