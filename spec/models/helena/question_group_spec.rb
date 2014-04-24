require 'spec_helper'

describe Helena::QuestionGroup do
  let!(:version) { create :version, survey: create(:survey) }

  it { expect(subject).to be_embedded_in(:version) }

  it 'has a valid factory' do
    expect(build :question_group).to be_valid
  end
end
