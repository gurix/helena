require 'spec_helper'

describe Helena::Question do
  let!(:version) { create :version, survey: create(:survey) }

  it { expect(subject).to be_embedded_in(:question_group) }
  it { expect(subject).to validate_uniqueness_of(:code) }

  it 'has a valid factory' do
    expect(build :question, question_group: build(:question_group)).to be_valid
  end
end
