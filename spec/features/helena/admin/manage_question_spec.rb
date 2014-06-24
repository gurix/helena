require 'spec_helper'

feature 'Question management' do
  let!(:draft_version) { create :version, survey: create(:survey), version: 0 }
  let!(:question_group) { create :question_group, version: draft_version }

  scenario 'lists all question groups of a certain survey' do
    first_question = create :question, question_text: 'Who are you?', question_group: question_group, position: 1
    second_question = create :question, question_text: 'Imagine an inivisible pony. What color has ist?', question_group: question_group, position: 2

    visit helena.admin_survey_question_group_questions_path(draft_version.survey, question_group)

    within "#helena_#{dom_id first_question}" do
      expect(page).to have_text 'Who are you?'
    end

    within "#helena_#{dom_id second_question}" do
      expect(page).to have_text 'Imagine an inivisible pony. What color has ist?'
    end

    within '.breadcrumb' do
      expect(page).to have_link'Surveys', href: helena.admin_surveys_path
      expect(page).to have_link draft_version.survey.name, href: helena.admin_survey_question_groups_path(draft_version.survey)
      expect(page).to have_text question_group.title
    end
  end

  scenario 'creates a new question' do
    visit helena.new_admin_survey_question_group_question_path(draft_version.survey, question_group)

    fill_in 'Code', with: 'a38'
    fill_in 'Question text', with: 'Shall we go?'

    within '.breadcrumb' do
      expect(page).to have_text 'New question'
    end

    expect { click_button 'Save' }.to change { question_group.reload.questions.count }.by(1)
  end

  scenario 'creating a new question errors when without entering a code' do
    visit helena.new_admin_survey_question_group_question_path(draft_version.survey, question_group)

    fill_in 'Code', with: ''

    expect { click_button 'Save' }.to change { question_group.reload.questions.count }.by(0)
  end

  scenario 'edits a question' do
    question = create :question, question_text: 'We are here?', question_group: question_group

    visit helena.edit_admin_survey_question_group_question_path(draft_version.survey, question.question_group, question)

    fill_in 'Question text', with: 'Are you sure?'
    fill_in 'Code', with: 'b12'

    click_button 'Save'

    expect(question.reload.question_text).to eq 'Are you sure?'
    expect(question.reload.code).to eq 'b12'
  end

  scenario 'edits a question errors when code text is empty' do
    question = create :question, question_text: 'We are here?', question_group: question_group

    visit helena.edit_admin_survey_question_group_question_path(draft_version.survey, question.question_group, question)

    fill_in 'Code', with: ''

    expect{ click_button 'Save' }.not_to change { question.reload }
  end

  scenario 'moving a question' do
    first_question = create :question, question_group: question_group, position: 1
    second_question = create :question, question_group: question_group, position: 2

    visit helena.admin_survey_question_group_questions_path(draft_version.survey, question_group)

    within "#helena_#{dom_id first_question}" do
      expect { click_link 'Move down' }.to change { first_question.reload.position }.from(1).to(2)
    end

    within "#helena_#{dom_id second_question}" do
      expect { click_link 'Move down' }.to change { second_question.reload.position }.from(1).to(2)
    end

    within  "#helena_#{dom_id second_question}" do
      expect { click_link 'Move up' }.to change { second_question.reload.position }.from(2).to(1)
    end

    within "#helena_#{dom_id first_question}" do
      expect { click_link 'Move up' }.to change { first_question.reload.position }.from(2).to(1)
    end
  end

  scenario 'deletes a question' do
    question = create :question, question_group: question_group

    visit helena.admin_survey_question_group_questions_path(draft_version.survey, question_group)

    within"#helena_#{dom_id question}" do
      expect { click_link 'Delete' }.to change { question_group.reload.questions.count }.by(-1)
    end
  end
end
