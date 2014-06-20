require 'spec_helper'

feature 'Short text question management' do
  let!(:draft_version) { create :version, survey: create(:survey), version: 0 }

  scenario 'edits a question' do
    question = create :short_text_question, question_group: create(:question_group, version: draft_version)

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.version.survey, question.question_group, question)

    fill_in 'Default value', with: 'Hey Hey!'
    check 'Required'

    click_button 'Save'

    expect(question.reload.default_value).to eq 'Hey Hey!'
    expect(question.reload.required).to eq true
  end
end
