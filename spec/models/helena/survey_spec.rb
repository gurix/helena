require 'spec_helper'

describe Helena::Survey do
  it { expect(subject).to have_many(:versions).with_dependent(:destroy) }
  it { expect(subject).to have_many(:sessions).with_dependent(:destroy) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:language) }
  it { expect(subject).to validate_uniqueness_of(:name) }

  it 'has a valid factory' do
    expect(build :survey).to be_valid
  end

  it 'is removable by default via Helena::Concerns::ApplicationModel.removable?' do
    survey = create :survey
    expect { survey.delete }.to change { Helena::Survey.count }.by(-1)
  end
end
