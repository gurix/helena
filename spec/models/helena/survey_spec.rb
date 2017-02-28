require 'spec_helper'

describe Helena::Survey do
  it { expect(subject).to have_many(:versions).with_dependent(:destroy) }
  it { expect(subject).to have_many(:sessions).with_dependent(:destroy) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:language) }
  it { expect(subject).to validate_uniqueness_of(:name) }

  it 'has a valid factory' do
    expect(build(:survey)).to be_valid
  end

  it 'returns the newest version if there are any' do
    survey = create :survey

    expect(survey.newest_version).to be_nil

    survey.versions.create version: 99
    survey.versions.create version: 0

    expect(survey.reload.newest_version.version).to be 99
  end
end
