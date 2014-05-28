require 'spec_helper'

describe Helena::Survey do
  it { expect(subject).to embed_many(:versions) }
  it { expect(subject).to have_many(:sessions).with_dependent(:destroy) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:language) }
  it { expect(subject).to validate_uniqueness_of(:name) }

  it 'has a valid factory' do
    expect(build :survey).to be_valid
  end
end
