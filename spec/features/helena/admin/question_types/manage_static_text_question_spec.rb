require 'spec_helper'

feature 'Static text question management' do

  let!(:question_group) { create :question_group }

  scenario 'edits a question' do
    question = create :static_text_question

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    fill_in 'Static text', with: 'This text will be displayed instead of an input'

    click_button 'Save'

    expect(question.reload.default_value).to eq 'This text will be displayed instead of an input'
  end
end
