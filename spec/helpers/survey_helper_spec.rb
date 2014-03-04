require 'spec_helper'

describe Helena::SurveyHelper do
  describe '#question_type_translation_for' do
    it 'returns the translated question type' do
      expect(helper.question_type_translation_for Helena::Questions::ShortText).to eq 'Short text'
    end

    it 'returns nothing for nil or empty' do
      expect(helper.question_type_translation_for nil).to be_nil
      expect(helper.question_type_translation_for '').to be_nil
    end
  end
end
