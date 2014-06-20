require 'spec_helper'

feature 'Radio matrix question management' do
  let!(:draft_version) { create :version, survey: create(:survey), version: 0 }
  let!(:question_group) { create(:question_group, version: draft_version) }

  scenario 'edits a question' do
    question = create :radio_matrix_question, question_group: question_group
    question.labels.create text: 'Strongly disagree', value: '-1', position: 1
    question.sub_questions.create code: 'aperto', text: 'Aperto Snacks', value: 'Aperto', position: 1

    visit helena.edit_admin_survey_question_group_question_path(draft_version.survey, question.question_group, question)

    check 'Required'

    fill_in 'questions_radio_matrix_labels_attributes_0_position', with: '2'
    fill_in 'questions_radio_matrix_labels_attributes_0_text', with: 'Strongly agree'
    fill_in 'questions_radio_matrix_labels_attributes_0_value', with: '1'
    check 'questions_radio_matrix_labels_attributes_0_preselected'

    fill_in 'questions_radio_matrix_sub_questions_attributes_0_position', with: '2'
    fill_in 'questions_radio_matrix_sub_questions_attributes_0_text', with: 'Avec Shop'
    fill_in 'questions_radio_matrix_sub_questions_attributes_0_code', with: 'avec'

    click_button 'Save'

    expect(question.reload.labels.first.position).to eq 2
    expect(question.reload.labels.first.text).to eq 'Strongly agree'
    expect(question.reload.labels.first.value).to eq '1'
    expect(question.reload.labels.first.preselected).to eq true

    expect(question.reload.sub_questions.first.position).to eq 2
    expect(question.reload.sub_questions.first.text).to eq 'Avec Shop'
    expect(question.reload.sub_questions.first.code).to eq 'avec'

    expect(question.reload.required).to eq true
  end

  scenario 'adds a an option' do
    question = create :radio_matrix_question, question_group: question_group

    visit helena.edit_admin_survey_question_group_questions_radio_matrix_path(draft_version.survey, question.question_group, question)

    fill_in 'questions_radio_matrix_labels_attributes_0_position', with: '2'
    fill_in 'questions_radio_matrix_labels_attributes_0_text', with: 'Strongly agree'
    fill_in 'questions_radio_matrix_labels_attributes_0_value', with: '1'
    check 'questions_radio_matrix_labels_attributes_0_preselected'

    fill_in 'questions_radio_matrix_sub_questions_attributes_0_position', with: '2'
    fill_in 'questions_radio_matrix_sub_questions_attributes_0_text', with: 'Avec Shop'
    fill_in 'questions_radio_matrix_sub_questions_attributes_0_code', with: 'avec'

    click_button 'Save'

    expect(question.reload.labels.first.position).to eq 2
    expect(question.reload.labels.first.text).to eq 'Strongly agree'
    expect(question.reload.labels.first.value).to eq '1'
    expect(question.reload.labels.first.preselected).to eq true

    expect(question.reload.sub_questions.first.position).to eq 2
    expect(question.reload.sub_questions.first.text).to eq 'Avec Shop'
    expect(question.reload.sub_questions.first.code).to eq 'avec'
  end

  scenario 'removes an option' do
    question = create :radio_matrix_question, question_group: question_group
    question.labels.create text: 'Male', value: 'm', position: 1
    question.sub_questions.create code: 'aperto', text: 'Aperto Snacks', value: 'Aperto', position: 1

    visit helena.edit_admin_survey_question_group_questions_radio_matrix_path(draft_version.survey, question.question_group, question)

    check 'questions_radio_matrix_labels_attributes_0__destroy'
    check 'questions_radio_matrix_sub_questions_attributes_0__destroy'

    click_button 'Save'

    expect(question.reload.labels).to be_empty
    expect(question.reload.sub_questions).to be_empty
  end
end
