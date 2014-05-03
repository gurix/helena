require 'spec_helper'

describe Helena::Question do
  let!(:version) { create :version, survey: create(:survey) }

  it { expect(subject).to be_embedded_in(:question_group) }

  it { expect(subject).to validate_presence_of(:code) }

  it 'validates uniqness of code across different question_groups' do
    a_question = build :question, question_group: build(:question_group, version: version), code: :preferred_color
    expect(a_question).to be_valid

    another_question = build :question, question_group: build(:question_group, version: version), code: :preferred_color
    expect(another_question).not_to be_valid
  end

  it 'has a valid factory' do
    expect(build :question, question_group: build(:question_group, version: version)).to be_valid
  end
end
