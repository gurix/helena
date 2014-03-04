require 'spec_helper'

feature 'Survey management' do
  scenario 'lists all surveys' do
    create :survey, name: 'My first survey', description: 'I am very proud of it'
    create :survey, name: 'Another cool survey', description: 'Everybody likes it'

    visit helena.admin_surveys_path

    within '#helena_survey_1' do
      expect(page).to have_text 'My first survey'
      expect(page).to have_text 'I am very proud of it'
    end

    within '#helena_survey_2' do
      expect(page).to have_text 'Another cool survey'
      expect(page).to have_text 'Everybody likes it'
    end

    within '.breadcrumb' do
      expect(page).to have_text 'Surveys'
    end
  end

  scenario 'creates a new surveys' do
    visit helena.new_admin_survey_path

    fill_in 'Name', with: 'More crazy stuff...'
    fill_in 'Description', with: 'Once upon a time.'

    within '.breadcrumb' do
      expect(page).to have_text 'New Survey'
    end

    click_button 'Save'

    within '#helena_survey_1' do
      expect(page).to have_text 'More crazy stuff...'
      expect(page).to have_text 'Once upon a time.'
    end
  end

  scenario 'edits a survey' do
    survey = create :survey, name: 'My first survey', description: 'I am very proud of it'

    visit helena.edit_admin_survey_path(survey)

    fill_in 'Name', with: 'More crazy stuff...'
    fill_in 'Description', with: 'Once upon a time.'

    click_button 'Save'

    within '#helena_survey_1' do
      expect(page).to have_text 'More crazy stuff...'
      expect(page).to have_text 'Once upon a time.'
    end
  end

  scenario 'edits a survey fails when name is empty' do
    survey = create :survey, name: 'My first survey', description: 'I am very proud of it'

    visit helena.edit_admin_survey_path(survey)

    fill_in 'Name', with: ''
    fill_in 'Description', with: 'Once upon a time.'

    click_button 'Save'

    expect(page).to have_text 'Ooopss... something is wrong, please check your input'

    within '.breadcrumb' do
      expect(page).to have_text 'My first survey'
    end
  end

  scenario 'deletes a survey' do
    create :survey

    visit helena.admin_surveys_path

    within '#helena_survey_1' do
      expect { click_link 'Delete' }.to change { Helena::Survey.count }.by(-1)
    end
  end

  scenario 'links to question groups of a survey' do
    survey = create :survey
    visit helena.admin_surveys_path

    within '#helena_survey_1' do
      expect(page).to have_link 'Question Groups', href: helena.admin_survey_question_groups_path(survey)
    end
  end

  scenario 'moving surveys' do
    first_survey = create :survey, position: 1
    second_survey = create :survey, position: 2

    visit helena.admin_surveys_path

    within '#helena_survey_1' do
      expect { click_link 'Move down' }.to change { first_survey.reload.position }.from(1).to(2)
    end

    within '#helena_survey_2' do
      expect { click_link 'Move down' }.to change { second_survey.reload.position }.from(1).to(2)
    end

    within '#helena_survey_2' do
      expect { click_link 'Move up' }.to change { second_survey.reload.position }.from(2).to(1)
    end

    within '#helena_survey_1' do
      expect { click_link 'Move up' }.to change { first_survey.reload.position }.from(2).to(1)
    end
  end
end
