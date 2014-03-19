require 'spec_helper'

feature 'Static text question management' do
  let!(:draft_version) { create :version, survey: create(:survey), version: 0 }

  scenario 'edits a question' do
    question = create :static_text_question, question_group: create(:question_group, version: draft_version)

    visit helena.edit_admin_survey_question_group_question_path(draft_version.survey, question.question_group, question)

    fill_in 'Static text', with: 'This text will be displayed instead of an input'

    click_button 'Save'

    expect(question.reload.default_value).to eq 'This text will be displayed instead of an input'
  end
end
