require 'spec_helper'

describe Helena::Questions::CheckboxMatrix do
  let!(:version) { create :version, survey: create(:survey) }

  let(:question_group) { build :question_group, version: version }

  it 'has a valid factory' do
    expect(build :checkbox_matrix_question).to be_valid
  end
end
