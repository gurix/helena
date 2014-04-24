require 'spec_helper'

feature 'Survey management' do
  scenario 'lists all surveys' do
    first_survey = create :survey, name: 'first'
    first_survey.versions.create version: 0
    first_survey.versions.first.survey_detail = Helena::SurveyDetail.new(title: 'My first survey', description: 'I am very proud of it')
    second_survey = create :survey, name: 'second'
    second_survey.versions.create version: 0
    second_survey.versions.first.survey_detail = Helena::SurveyDetail.new(title: 'Another cool survey', description: 'Everybody likes it')

    visit helena.surveys_path

    within "#helena_#{dom_id first_survey}" do
      expect(page).to have_text 'My first survey'
      expect(page).to have_text 'I am very proud of it'
    end

    within "#helena_#{dom_id second_survey}" do
      expect(page).to have_text 'Another cool survey'
      expect(page).to have_text 'Everybody likes it'
    end
  end
end
