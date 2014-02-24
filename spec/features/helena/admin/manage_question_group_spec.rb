require 'spec_helper'

feature 'Question group management' do

  let!(:survey) { create :survey }

  scenario 'lists all question groups of a certain survey' do
    create :question_group, title: 'Introduction', survey: survey, group_order: 1
    create :question_group, title: 'Food behaviour', survey: survey, group_order: 2

    visit helena.admin_survey_question_groups_path(survey)

    within '#helena_question_group_1' do
      expect(page).to have_text '1 Introduction'
    end

    within '#helena_question_group_2' do
      expect(page).to have_text '2 Food behaviour'
    end

    within '.breadcrumb' do
      expect(page).to have_text 'Surveys'
      expect(page).to have_text survey.name
    end
  end

  scenario 'creates a new question group' do
    visit helena.new_admin_survey_question_group_path(survey)

    fill_in 'Title', with: 'Welcome Message'

    within '.breadcrumb' do
      expect(page).to have_text 'New question group'
    end

    click_button 'Save'

    within '#helena_question_group_1' do
      expect(page).to have_text '1 Welcome Message'
    end
  end

  scenario 'edits a question_group' do
    question_group = create :question_group, title: 'Some stupid questions', survey: survey, group_order: 2
    create :question_group, title: 'Some final remarks', survey: survey, group_order: 1

    visit helena.edit_admin_survey_question_group_path(survey, question_group)

    fill_in 'Title', with: 'Some serious question'

    click_button 'Save'

    within '#helena_question_group_1' do
      expect(page).to have_text '2 Some serious question'
    end

    within '#helena_question_group_2' do
      expect(page).to have_text '1 Some final remarks'
    end
  end

  scenario 'deletes a question group' do
    create :question_group, title: 'We do not use this anymore', survey: survey

    visit helena.admin_survey_question_groups_path(survey)

    within '#helena_question_group_1' do
      expect { click_link 'Delete' }.to change { survey.question_groups.count }.by(-1)
    end
  end
end
