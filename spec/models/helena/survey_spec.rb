require 'spec_helper'

describe Helena::Survey do
  it { expect(subject).to belong_to(:participant) }

  it { expect(subject).to have_many(:question_groups).dependent(:destroy) }
  it { expect(subject).to have_many(:questions).dependent(:destroy) }
  it { expect(subject).to have_many(:versions).dependent(:destroy) }

  it 'has a valid factory' do
    expect(build :survey).to be_valid
  end

  it 'validates presence of name' do
    expect(build :survey, name: '').not_to be_valid
  end

  it 'validates uniqueness of name' do
    create :survey, name: 'Patric Star\'s favorit position'

    expect(build :survey, name: 'Patric Star\'s favorit position').not_to be_valid
  end

  it 'sorts by default according the position' do
    last_survey = create :survey, position: 99
    first_survey = create :survey, position: 11

    expect(Helena::Survey.first).to eq first_survey
    expect(Helena::Survey.last).to eq last_survey
  end

  describe '#swap_position' do
    let!(:last_survey) { create :survey, position: 99 }
    let!(:first_survey) { create :survey, position: 11 }

    it 'swaps two surveys' do
      last_survey.swap_position(11)

      expect(first_survey.reload.position).to eq 99
      expect(last_survey.reload.position).to eq 11
    end

    it 'does not swaps unknown position' do
      last_survey.swap_position(666)

      expect(first_survey.reload.position).to eq 11
      expect(last_survey.reload.position).to eq 99
    end
  end

  describe '#resort' do
    it 'resorts all surveys' do
      last_survey = create :survey, position: 99
      first_survey = create :survey, position: 11

      Helena::Survey.resort

      expect(first_survey.reload.position).to eq 1
      expect(last_survey.reload.position).to eq 2
    end
  end
end
