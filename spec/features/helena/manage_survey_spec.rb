require 'spec_helper'

feature 'Survey management' do
  scenario 'lists all surveys' do
    create :survey, name: 'My first survey'
    create :survey, name: 'Another cool survey'

    visit helena.surveys_path

    within '#helena_survey_1' do
      expect(page).to have_text '1 My first survey'
    end

    within '#helena_survey_2' do
      expect(page).to have_text '2 Another cool survey'
    end
  end

  scenario 'creates a new surveys'
  scenario 'edits a survey'
  scenario 'delets a survey'

end
