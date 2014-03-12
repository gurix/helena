require 'spec_helper'

describe Helena::QuestionGroup do
  let!(:survey) { create :survey }

  it { expect(subject).to belong_to(:survey) }
  it { expect(subject).to validate_presence_of(:version) }

  it 'has a valid factory' do
    expect(build :question_group).to be_valid
  end

  it 'sorts by default according the position' do
    last_question_group = create :question_group, survey: survey, position: 99
    first_question_group = create :question_group, survey: survey, position: 11

    expect(Helena::QuestionGroup.first).to eq first_question_group
    expect(Helena::QuestionGroup.last).to eq last_question_group
  end

  describe '#swap_position' do
    let!(:last_question_group) { create :question_group, survey: survey, position: 99 }
    let!(:first_question_group) { create :question_group, survey: survey, position: 11 }

    it 'swaps two surveys' do
      last_question_group.swap_position 11

      expect(first_question_group.reload.position).to eq 99
      expect(last_question_group.reload.position).to eq 11
    end

    it 'does not swaps unknown position' do
      last_question_group.swap_position 666

      expect(first_question_group.reload.position).to eq 11
      expect(last_question_group.reload.position).to eq 99
    end
  end

  describe '#resort' do
    it 'resorts all surveys' do
      last_question_group = create :question_group, survey: survey, position: 99
      first_question_group = create :question_group, survey: survey, position: 11

      Helena::QuestionGroup.resort(survey)

      expect(first_question_group.reload.position).to eq 1
      expect(last_question_group.reload.position).to eq 2
    end
  end
end
