require 'spec_helper'

describe Helena::Answer do
  it { expect(subject).to be_embedded_in(:session) }

  it { expect(subject).to validate_presence_of(:code) }
  it { expect(subject).to validate_uniqueness_of(:code) }
  it { expect(subject).to validate_presence_of(:ip_address) }

  it 'has a valid factory' do
    expect(build :answer).to be_valid
  end
end
