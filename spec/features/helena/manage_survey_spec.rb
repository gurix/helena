require 'spec_helper'

feature 'Survey management' do
  scenario 'lists all surveys' do
    create :survey, name: 'My first survey', description: 'I am very proud of it'
    create :survey, name: 'Another cool survey', description: 'Everybody likes it'

    visit helena.surveys_path

    within '#helena_survey_1' do
      expect(page).to have_text 'My first survey'
      expect(page).to have_text 'I am very proud of it'
    end

    within '#helena_survey_2' do
      expect(page).to have_text 'Another cool survey'
      expect(page).to have_text 'Everybody likes it'
    end
  end

  scenario 'creates a new surveys'

  scenario 'edits a survey' do
    survey = create :survey, name: 'My first survey', description: 'I am very proud of it'

    visit helena.edit_survey_path(survey)

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

    visit helena.edit_survey_path(survey)

    fill_in 'Name', with: ''
    fill_in 'Description', with: 'Once upon a time.'

    click_button 'Save'

    expect(page).to have_text 'Ooopss... something is wrong, please check your input'
  end

  scenario 'deletes a survey' do
    create :survey, name: 'My first survey', description: 'I am very proud of it'

    visit helena.surveys_path

    within '#helena_survey_1' do
      expect { click_link 'Delete' }.to change { Helena::Survey.count }.by(-1)
    end
  end

  scenario 'trying to delete a survey without authorization throws you an error'
end
