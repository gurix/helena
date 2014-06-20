require 'spec_helper'

feature 'Radio group question management' do
  let!(:draft_version) { create :version, survey: create(:survey), version: 0 }
  let!(:question_group) { create(:question_group, version: draft_version) }

  scenario 'edits a question' do
    question = create :radio_group_question, question_group: question_group
    question.labels << build(:label, text: 'Male', value: 'm', position: 1)

    visit helena.edit_admin_survey_question_group_question_path(draft_version.survey, question.question_group, question)

    check 'Required'

    fill_in 'questions_radio_group_labels_attributes_0_position', with: '2'
    fill_in 'questions_radio_group_labels_attributes_0_text', with: 'Female'
    fill_in 'questions_radio_group_labels_attributes_0_value', with: 'f'
    check 'questions_radio_group_labels_attributes_0_preselected'

    click_button 'Save'

    expect(question.reload.labels.first.position).to eq 2
    expect(question.reload.labels.first.text).to eq 'Female'
    expect(question.reload.labels.first.value).to eq 'f'
    expect(question.reload.labels.first.preselected).to eq true
    expect(question.reload.required).to eq true
  end

  scenario 'adds a an option' do
    question = create :radio_group_question, question_group: question_group

    visit helena.edit_admin_survey_question_group_questions_radio_group_path(draft_version.survey, question.question_group, question)

    fill_in 'questions_radio_group_labels_attributes_0_position', with: '2'
    fill_in 'questions_radio_group_labels_attributes_0_text', with: 'Female'
    fill_in 'questions_radio_group_labels_attributes_0_value', with: 'f'
    check 'questions_radio_group_labels_attributes_0_preselected'

    click_button 'Save'

    expect(question.reload.labels.first.position).to eq 2
    expect(question.reload.labels.first.text).to eq 'Female'
    expect(question.reload.labels.first.value).to eq 'f'
    expect(question.reload.labels.first.preselected).to eq true
  end

  scenario 'removes an option' do
    question = create :radio_group_question, question_group: question_group
    question.labels << build(:label, text: 'Male', value: 'm', position: 1)

    visit helena.edit_admin_survey_question_group_questions_radio_group_path(draft_version.survey, question.question_group, question)

    check 'questions_radio_group_labels_attributes_0__destroy'

    click_button 'Save'

    expect(question.reload.labels).to be_empty
  end
end
