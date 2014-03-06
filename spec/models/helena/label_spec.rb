require 'spec_helper'

describe Helena::Label do

  it { expect(subject).to belong_to(:question) }
  it { expect(subject).to validate_presence_of(:text) }
  it { expect(subject).to validate_presence_of(:value) }

  it 'has a valid factory' do
    expect(build :label).to be_valid
  end
end
