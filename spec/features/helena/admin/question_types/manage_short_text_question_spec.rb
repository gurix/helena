require 'spec_helper'

feature 'Short text question management' do

  let!(:question_group) { create :question_group }

  scenario 'edits a question' do
    question = create :short_text_question, question_text: 'We are here?'

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    fill_in 'Default value', with: 'Hey Hey!'

    click_button 'Save'

    expect(question.reload.default_value).to eq 'Hey Hey!'
  end
end
