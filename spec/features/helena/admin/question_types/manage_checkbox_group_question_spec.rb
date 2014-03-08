require 'spec_helper'

feature 'Checkbox group question management' do
  scenario 'edits a question' do
    question = create :checkbox_group_question
    question.sub_questions << create(:sub_question, code: 'aperto', question_text: 'Aperto Snacks', default_value: 'Aperto', position: 1)

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    check 'Required'

    fill_in 'question_sub_questions_attributes_0_position', with: '2'
    fill_in 'question_sub_questions_attributes_0_question_text', with: 'Avec Shop'
    fill_in 'question_sub_questions_attributes_0_default_value', with: 'Avec'
    fill_in 'question_sub_questions_attributes_0_code', with: 'avec'
    check 'question_sub_questions_attributes_0_preselected'

    click_button 'Save'

    expect(question.reload.sub_questions.first.position).to eq 2
    expect(question.reload.sub_questions.first.question_text).to eq 'Avec Shop'
    expect(question.reload.sub_questions.first.default_value).to eq 'Avec'
    expect(question.reload.sub_questions.first.code).to eq 'avec'
    expect(question.reload.required).to be_true
  end

  scenario 'adds a a sub question' do
    question = create :checkbox_group_question

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    fill_in 'question_sub_questions_attributes_0_position', with: '2'
    fill_in 'question_sub_questions_attributes_0_question_text', with: 'Avec Shop'
    fill_in 'question_sub_questions_attributes_0_default_value', with: 'Avec'
    fill_in 'question_sub_questions_attributes_0_code', with: 'avec'
    check 'question_sub_questions_attributes_0_preselected'

    click_button 'Save'

    expect(question.reload.sub_questions.first.position).to eq 2
    expect(question.reload.sub_questions.first.question_text).to eq 'Avec Shop'
    expect(question.reload.sub_questions.first.default_value).to eq 'Avec'
    expect(question.reload.sub_questions.first.code).to eq 'avec'
  end

  scenario 'removes a sub question' do
    question = create :checkbox_group_question
    question.sub_questions << create(:sub_question, code: 'aperto', question_text: 'Aperto Snacks', default_value: 'Aperto', position: 1)

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    check 'question_sub_questions_attributes_0__destroy'

    click_button 'Save'

    expect(question.reload.labels).to be_empty
  end
end
