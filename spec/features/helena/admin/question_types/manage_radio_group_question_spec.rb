require 'spec_helper'

feature 'Radio group question management' do
  scenario 'edits a question' do
    question = create :radio_group_question
    question.labels << create(:label, text: 'Male', value: 'm', position: 1)

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    check 'Required'

    fill_in 'questions_radio_group_labels_attributes_0_position', with: '2'
    fill_in 'questions_radio_group_labels_attributes_0_text', with: 'Female'
    fill_in 'questions_radio_group_labels_attributes_0_value', with: 'f'
    check 'questions_radio_group_labels_attributes_0_preselected'

    click_button 'Save'

    expect(question.reload.labels.first.position).to eq 2
    expect(question.reload.labels.first.text).to eq 'Female'
    expect(question.reload.labels.first.value).to eq 'f'
    expect(question.reload.required).to be_true
  end

  scenario 'adds a an option' do
    question = create :radio_group_question

    visit helena.edit_admin_survey_question_group_questions_radio_group_path(question.question_group.survey, question.question_group, question)

    fill_in 'questions_radio_group_labels_attributes_0_position', with: '2'
    fill_in 'questions_radio_group_labels_attributes_0_text', with: 'Female'
    fill_in 'questions_radio_group_labels_attributes_0_value', with: 'f'
    check 'questions_radio_group_labels_attributes_0_preselected'

    click_button 'Save'

    expect(question.reload.labels.first.position).to eq 2
    expect(question.reload.labels.first.text).to eq 'Female'
    expect(question.reload.labels.first.value).to eq 'f'
  end

  scenario 'removes an option' do
    question = create :radio_group_question
    question.labels << create(:label, text: 'Male', value: 'm', position: 1)

    visit helena.edit_admin_survey_question_group_questions_radio_group_path(question.question_group.survey, question.question_group, question)

    check 'questions_radio_group_labels_attributes_0__destroy'

    click_button 'Save'

    expect(question.reload.labels).to be_empty
  end
end
