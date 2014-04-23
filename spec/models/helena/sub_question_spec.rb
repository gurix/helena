require 'spec_helper'

describe Helena::SubQuestion do
  let(:version) { create :version, survey: create(:survey) }
  let(:question_group) { build :question_group, version: version }
  let(:question) { build :checkbox_matrix_question, question_group: question_group }

  it { expect(subject).to be_embedded_in(:question) }
  it { expect(subject).to validate_uniqueness_of(:code) }
  it { expect(subject).to validate_presence_of(:code) }
  it { expect(subject).to validate_uniqueness_of(:code) }
  it { expect(subject).to validate_presence_of(:text) }

  it 'has a valid factory' do
    expect(build :sub_question, question: question).to be_valid
  end
end
