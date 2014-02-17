require 'spec_helper'

describe Helena::Participant do

  it { expect(subject).to have_many(:surveys) }

  it 'has a valid factory' do
    expect(build :participant).to be_valid
  end
end
