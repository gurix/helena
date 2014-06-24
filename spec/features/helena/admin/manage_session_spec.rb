require 'spec_helper'
include ActionView::RecordIdentifier

feature 'Session management' do
  background do
    @survey = create :survey
    baseversion = @survey.versions.create version: 0
    @version = Helena::VersionPublisher.publish baseversion
    @version.save
  end

  scenario 'lists all sessions of a survey' do
    session_not_completed = @survey.sessions.create version: @version, token: 'abc'
    session_completed = @survey.sessions.create version: @version, token: 'xyz', completed: true

    visit helena.admin_survey_sessions_path @survey

    within "#helena_#{dom_id session_not_completed}" do
      expect(page).to have_text 'less than a minute abc No'
    end

    within "#helena_#{dom_id session_completed}" do
      expect(page).to have_text 'less than a minute xyz Yes'
    end

    within '.breadcrumb' do
      expect(page).to have_text 'Surveys'
      expect(page).to have_text @survey.name
    end
  end

  scenario 'deletes a version' do
    session = @survey.sessions.create

    visit helena.admin_survey_sessions_path @survey
    within "#helena_#{dom_id(session)}" do
      expect { click_link 'Delete' }.to change { @survey.sessions.count }.by(-1)
    end
  end
end
