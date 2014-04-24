require 'spec_helper'

feature 'Question group management' do

  let!(:survey) { create :survey }
  let!(:draft_version) { create :version, survey: survey, version: 0 }

  scenario 'lists all question groups of a certain survey' do
    first_question_group = create :question_group, title: 'Introduction', version: draft_version, position: 1
    second_question_group = create :question_group, title: 'Food behaviour', version: draft_version, position: 2

    visit helena.admin_survey_question_groups_path(survey)

    within "#helena_#{dom_id first_question_group}" do
      expect(page).to have_text '1 Introduction'
    end

    within "#helena_#{dom_id second_question_group}" do
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

    expect { click_button 'Save' }.to change { draft_version.reload.question_groups.count }.by(1)
  end

  scenario 'edits a question_group' do
    first_question_group = create :question_group, title: 'Some stupid questions', version: draft_version, position: 2
    second_question_group = create :question_group, title: 'Some final remarks', version: draft_version, position: 1

    visit helena.edit_admin_survey_question_group_path(survey, first_question_group)

    fill_in 'Title', with: 'Some serious question'

    click_button 'Save'

    within "#helena_#{dom_id first_question_group}" do
      expect(page).to have_text '2 Some serious question'
    end

    within "#helena_#{dom_id second_question_group}" do
      expect(page).to have_text '1 Some final remarks'
    end
  end

  scenario 'deletes a question group' do
    question_group = create :question_group, title: 'We do not use this anymore', version: draft_version

    visit helena.admin_survey_question_groups_path(survey)

    within "#helena_#{dom_id question_group}" do
      expect { click_link 'Delete' }.to change { draft_version.reload.question_groups.count }.by(-1)
    end
  end

  scenario 'links to questions of a question group' do
    question_group = create :question_group, title: 'We do not use this anymore', version: draft_version

    visit helena.admin_survey_question_groups_path(survey)

    within "#helena_#{dom_id question_group}" do
      expect(page).to have_link 'Questions', href: helena.admin_survey_question_group_questions_path(survey, question_group)
    end
  end

  scenario 'moving a question group' do
    first_question_group = create :question_group, version: draft_version, position: 1
    second_question_group = create :question_group, version: draft_version, position: 2

    visit helena.admin_survey_question_groups_path(survey)

    within "#helena_#{dom_id first_question_group}" do
      expect { click_link 'Move down' }.to change { first_question_group.reload.position }.from(1).to(2)
    end

    within "#helena_#{dom_id second_question_group}" do
      expect { click_link 'Move down' }.to change { second_question_group.reload.position }.from(1).to(2)
    end

    within "#helena_#{dom_id second_question_group}" do
      expect { click_link 'Move up' }.to change { second_question_group.reload.position }.from(2).to(1)
    end

    within "#helena_#{dom_id first_question_group}" do
      expect { click_link 'Move up' }.to change { first_question_group.reload.position }.from(2).to(1)
    end
  end
end
