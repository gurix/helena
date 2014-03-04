require 'spec_helper'

feature 'Question management' do

  let!(:question_group) { create :question_group }

  scenario 'lists all question groups of a certain survey' do
    create :question, question_text: 'Who are you?', question_group: question_group, position: 1
    create :question, question_text: 'Imagine an inivisible pony. What color has ist?', question_group: question_group, position: 2

    visit helena.admin_survey_question_group_questions_path(question_group.survey, question_group)

    within '#helena_question_1' do
      expect(page).to have_text 'Who are you?'
    end

    within '#helena_question_2' do
      expect(page).to have_text 'Imagine an inivisible pony. What color has ist?'
    end

    within '.breadcrumb' do
      expect(page).to have_link'Surveys', href: helena.admin_surveys_path
      expect(page).to have_link question_group.survey.name, href: helena.admin_survey_question_groups_path(question_group.survey)
      expect(page).to have_text question_group.title
    end
  end

  scenario 'creates a new question' do
    visit helena.new_admin_survey_question_group_question_path(question_group.survey, question_group)

    fill_in 'Code', with: 'A38'
    fill_in 'Question text', with: 'Shall we go?'

    within '.breadcrumb' do
      expect(page).to have_text 'New question'
    end

    expect { click_button 'Save' }.to change { Helena::Question.count }.by(1)

    expect(Helena::Question.last.survey).to eq question_group.survey
  end

  scenario 'edits a question' do
    question = create :question, question_text: 'We are here?'

    visit helena.edit_admin_survey_question_group_question_path(question.question_group.survey, question.question_group, question)

    fill_in 'Question text', with: 'Are you sure?'
    fill_in 'Code', with: 'B12'
    check 'Required'

    click_button 'Save'

    expect(question.reload.question_text).to eq 'Are you sure?'
    expect(question.reload.code).to eq 'B12'
    expect(question.reload.required).to be_true
  end

  scenario 'moving a question' do
    first_question = create :question, question_group: question_group, position: 1
    second_question = create :question, question_group: question_group, position: 2

    visit helena.admin_survey_question_group_questions_path(question_group.survey, question_group)

    within '#helena_question_1' do
      expect { click_link 'Move down' }.to change { first_question.reload.position }.from(1).to(2)
    end

    within '#helena_question_2' do
      expect { click_link 'Move down' }.to change { second_question.reload.position }.from(1).to(2)
    end

    within '#helena_question_2' do
      expect { click_link 'Move up' }.to change { second_question.reload.position }.from(2).to(1)
    end

    within '#helena_question_1' do
      expect { click_link 'Move up' }.to change { first_question.reload.position }.from(2).to(1)
    end
  end

  scenario 'deletes a question' do
    create :question, question_group: question_group

    visit helena.admin_survey_question_group_questions_path(question_group.survey, question_group)

    within '#helena_question_1' do
      expect { click_link 'Delete' }.to change { question_group.questions.count }.by(-1)
    end
  end
end
