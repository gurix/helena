require 'spec_helper'

feature 'Survey management' do
  scenario 'lists all surveys' do
    first_survey = create :survey, name: 'first', tag_list: 'foo, bar'
    first_survey.versions.create version: 0
    first_survey.versions.first.survey_detail = Helena::SurveyDetail.new(title: 'My first survey', description: 'I am very proud of it')
    second_survey = create :survey, name: 'second', tag_list: 'cumulus, nimbus'
    second_survey.versions.create version: 0
    second_survey.versions.first.survey_detail = Helena::SurveyDetail.new(title: 'Another cool survey', description: 'Everybody likes it')

    visit helena.admin_surveys_path

    within "#helena_#{dom_id first_survey}" do
      expect(page).to have_text 'first'
      expect(page).to have_text 'My first survey'
      expect(page).to have_text 'I am very proud of it'
      expect(page).to have_text 'foo, bar'
    end

    within "#helena_#{dom_id second_survey}" do
      expect(page).to have_text 'second'
      expect(page).to have_text 'Another cool survey'
      expect(page).to have_text 'Everybody likes it'
      expect(page).to have_text 'cumulus, nimbus'
    end

    within '.breadcrumb' do
      expect(page).to have_text 'Surveys'
    end
  end

  scenario 'creates a new surveys' do
    visit helena.new_admin_survey_path

    fill_in 'Name', with: 'More crazy stuff...'
    fill_in 'Description', with: 'Once upon a time.'
    fill_in 'Tag list', with: 'english, foo, 42'

    within '.breadcrumb' do
      expect(page).to have_text 'New Survey'
    end

    expect { click_button 'Save' }.to change { Helena::Survey.count }.by 1

  end

  scenario 'edits a survey' do
    survey = create :survey, name: 'first'
    survey.versions.create version: 0
    survey.versions.first.survey_detail = Helena::SurveyDetail.new(title: 'My first survey', description: 'I am very proud of it')

    visit helena.edit_admin_survey_path(survey)

    fill_in 'Name', with: 'This is crazy'
    fill_in 'Title', with: 'More crazy stuff...'
    fill_in 'Description', with: 'Once upon a time.'
    fill_in 'Tag list', with: 'english, foo, 42'

    click_button 'Save'

    within "#helena_#{dom_id survey}" do
      expect(page).to have_text 'This is crazy'
      expect(page).to have_text 'More crazy stuff...'
      expect(page).to have_text 'Once upon a time.'
    end
  end

  scenario 'edits a survey fails when name is empty' do
    survey = create :survey, name: 'the first one'
    survey.versions.create version: 0
    survey.versions.first.survey_detail = Helena::SurveyDetail.new(title: 'My first survey', description: 'I am very proud of it')

    visit helena.edit_admin_survey_path(survey)

    fill_in 'Name', with: ''
    fill_in 'Description', with: 'Once upon a time.'

    click_button 'Save'

    expect(page).to have_text "Name can't be blank"

    within '.breadcrumb' do
      expect(page).to have_text 'the first one'
    end
  end

  scenario 'deletes a survey' do
    survey = create :survey, name: 'the first one'
    survey.versions.create version: 0

    visit helena.admin_surveys_path

    within "#helena_#{dom_id survey}" do
      expect { click_link 'Delete' }.to change { Helena::Survey.count }.by(-1)
    end
  end

  scenario 'links to question groups of a survey' do
    survey = create :survey, name: 'the first one'
    survey.versions.create version: 0

    visit helena.admin_surveys_path

    within "#helena_#{dom_id survey}" do
      expect(page).to have_link 'Question Groups', href: helena.admin_survey_question_groups_path(survey)
    end
  end

  scenario 'moving surveys' do
    first_survey = create :survey, name: 'first', position: 1
    first_survey.versions.create version: 0
    second_survey = create :survey, name: 'second', position: 2
    second_survey.versions.create version: 0

    visit helena.admin_surveys_path

    within "#helena_#{dom_id first_survey}" do
      expect { click_link 'Move down' }.to change { first_survey.reload.position }.from(1).to(2)
    end

    within "#helena_#{dom_id second_survey}" do
      expect { click_link 'Move down' }.to change { second_survey.reload.position }.from(1).to(2)
    end

    within "#helena_#{dom_id second_survey}" do
      expect { click_link 'Move up' }.to change { second_survey.reload.position }.from(2).to(1)
    end

    within "#helena_#{dom_id first_survey}" do
      expect { click_link 'Move up' }.to change { first_survey.reload.position }.from(2).to(1)
    end
  end
end
