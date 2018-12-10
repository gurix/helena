require 'spec_helper'

describe Helena::SubQuestion do
  let(:version) { create :version, survey: create(:survey) }
  let(:question_group) { build :question_group, version: version }
  let(:question) { build :radio_matrix_question, question_group: question_group }

  it { expect(subject).to be_embedded_in(:question) }
  it { expect(subject).to validate_uniqueness_of(:text) }
  it { expect(subject).to validate_presence_of(:text) }

  it 'validates uniqness of code across different question_groups with subquestions' do
    a_question = build :question, question_group: build(:question_group, version: version), code: :preferred_color
    expect(a_question).to be_valid

    another_question = build :question, question_group: build(:question_group, version: version), code: :colors

    sub_question = build :sub_question, question: another_question, code: :some_code
    expect(sub_question).to be_valid

    another_sub_question = build :sub_question, question: another_question, code: :preferred_color
    expect(another_sub_question).not_to be_valid
  end

  it 'has a valid factory' do
    expect(build(:sub_question, question: question)).to be_valid
  end

  describe 'splitting the sub_question text with a vertical bar "|" i.e for pair comparisions' do
    it 'recognize splitted sub questions' do
      normal_sub_question = build :sub_question, question: question, text: 'just an ordinary subquestion'

      expect(normal_sub_question.splitted?).to be false

      splitted_sub_question = build :sub_question, question: question, text: 'i am|splitted'

      expect(splitted_sub_question.splitted?).to be true
    end

    it 'returns correct parts' do
      splitted_sub_question = build :sub_question, question: question, text: 'first|last'

      expect(splitted_sub_question.parts).to eq %w[first last]
    end
  end
end
