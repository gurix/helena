require 'spec_helper'

describe Participant do

  it { expect(subject).to have_many(:surveys) }

  it 'has a valid factory' do
    expect(build :participant).to be_valid
  end
end
