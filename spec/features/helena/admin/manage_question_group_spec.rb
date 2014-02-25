require 'spec_helper'

feature 'Question group management' do

  let!(:survey) { create :survey }

  scenario 'lists all question groups of a certain survey' do
    create :question_group, title: 'Introduction', survey: survey, position: 1
    create :question_group, title: 'Food behaviour', survey: survey, position: 2

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
    question_group = create :question_group, title: 'Some stupid questions', survey: survey, position: 2
    create :question_group, title: 'Some final remarks', survey: survey, position: 1

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

  scenario 'moving a question gropu' do
    first_question_group = create :question_group, survey: survey, position: 1
    second_question_group = create :question_group, survey: survey, position: 2

    visit helena.admin_survey_question_groups_path(survey)

    within '#helena_question_group_1' do
      expect { click_link 'Move down' }.to change { first_question_group.reload.position }.from(1).to(2)
    end

    within '#helena_question_group_2' do
      expect { click_link 'Move down' }.to change { second_question_group.reload.position }.from(1).to(2)
    end

    within '#helena_question_group_2' do
      expect { click_link 'Move up' }.to change { second_question_group.reload.position }.from(2).to(1)
    end

    within '#helena_question_group_1' do
      expect { click_link 'Move up' }.to change { first_question_group.reload.position }.from(2).to(1)
    end
  end
end
