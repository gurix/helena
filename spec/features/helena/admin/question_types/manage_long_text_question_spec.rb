require 'spec_helper'

feature 'Long text question management' do
  let!(:draft_version) { create :version, survey: create(:survey), version: 0 }

  scenario 'edits a question' do
    question = create :long_text_question, question_group: create(:question_group, version: draft_version)

    visit helena.edit_admin_survey_question_group_question_path(draft_version.survey, question.question_group, question)

    a_very_long_text = Faker::Lorem.paragraph(20)

    fill_in 'Default value', with: a_very_long_text
    check 'Required'

    click_button 'Save'

    expect(question.reload.default_value).to eq a_very_long_text
    expect(question.reload.required).to be_true
  end
end
