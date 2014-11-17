require 'spec_helper'

describe Helena::Version do
  it { expect(subject).to belong_to(:survey) }

  it { expect(subject).to have_many(:question_groups).with_dependent(:destroy) }
  it { expect(subject).to embed_one(:survey_detail) }

  it { expect(subject).to validate_presence_of(:version) }
  it { expect(subject).to validate_uniqueness_of(:version) }

  it 'has a valid factory' do
    expect(build :version, survey: create(:survey)).to be_valid
  end

  it 'scopes active versions' do
    survey = create :survey
    survey.versions.create version: 0
    survey.versions.create active: true, version: 1

    expect(survey.reload.versions.size).to eq 2
    expect(survey.reload.versions.active.size).to eq 1
  end
end
