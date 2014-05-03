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

  describe '.build_generic' do
    it 'builds an integer answer' do
      expect(Helena::Answer.build_generic('bla', 42, '192.168.0.1')).to be_kind_of(Helena::IntegerAnswer)
    end

    it 'builds an integer answer from a string integer' do
      expect(Helena::Answer.build_generic('bla', '42', '192.168.0.1')).to be_kind_of(Helena::IntegerAnswer)
    end

    it 'builds a string answer' do
      expect(Helena::Answer.build_generic('bla', 'look at my horse, my horse is a amazing', '192.168.0.1')).to be_kind_of(Helena::StringAnswer)
    end

    it 'builds a boolean answer for string "true"' do
      expect(Helena::Answer.build_generic('bla', 'true', '192.168.0.1')).to be_kind_of(Helena::BooleanAnswer)
    end

    it 'builds a boolean answer for string "false"' do
      expect(Helena::Answer.build_generic('bla', 'false', '192.168.0.1')).to be_kind_of(Helena::BooleanAnswer)
    end

    it 'builds a boolean answer for true' do
      expect(Helena::Answer.build_generic('bla', 'true', '192.168.0.1')).to be_kind_of(Helena::BooleanAnswer)
    end

    it 'builds a boolean answer for false' do
      expect(Helena::Answer.build_generic('bla', 'false', '192.168.0.1')).to be_kind_of(Helena::BooleanAnswer)
    end
  end

end
