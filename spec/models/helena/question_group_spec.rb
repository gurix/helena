require 'spec_helper'

describe Helena::QuestionGroup do
  let!(:version) { create :version, survey: create(:survey) }

  it { expect(subject).to have_many(:questions).with_dependent(:destroy) }
  it { expect(subject).to belong_to(:version) }

  it 'has a valid factory' do
    expect(build :question_group, version: version).to be_valid
  end
end
