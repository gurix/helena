require 'spec_helper'

describe Helena::Questions::CheckboxMatrix do
  let!(:version) { build :version, survey: build(:survey) }

  let(:question_group) { build :question_group, version: version }

  it 'has a valid factory' do
    expect(build :checkbox_matrix_question, question_group: question_group).to be_valid
  end
end
