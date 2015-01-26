require 'spec_helper'

describe Helena::Label do
  it { expect(subject).to be_embedded_in(:question) }
  it { expect(subject).to validate_presence_of(:text) }
  it { expect(subject).to validate_presence_of(:value) }
  it { expect(subject).to validate_uniqueness_of(:value) }

  it 'has a valid factory' do
    expect(build :label).to be_valid
  end
end
