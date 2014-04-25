require 'spec_helper'

describe Helena::Answer do

  let(:survey) { create :survey }
  let(:version) { build :version, survey: survey }
  let(:session) { create :session, survey: survey, version: version }

  it { expect(subject).to be_embedded_in(:session) }

  it { expect(subject).to validate_presence_of(:code) }
  it { expect(subject).to validate_uniqueness_of(:code) }
  it { expect(subject).to validate_presence_of(:ip_address) }

  it 'saves the created_at time when create an answer' do
    expect(build(:answer).created_at).to be_kind_of(DateTime)
  end

  it 'has a valid factory' do
    expect(build :answer).to be_valid
  end
end
