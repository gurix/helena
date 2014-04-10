require 'spec_helper'
include ActionView::RecordIdentifier

feature 'Version management' do
  background do
    @survey = create :survey
    @baseversion = @survey.versions.create version: 0
  end

  scenario 'lists all versions of a survey' do
    published_version = Helena::VersionPublisher.publish(@baseversion)
    published_version.notes = 'bla bla'
    published_version.save

    visit helena.admin_survey_versions_path(@survey)

    expect(page).not_to have_selector "#helena_#{dom_id(@baseversion)}" # Base version is always the working version

    within "#helena_#{dom_id(published_version)}" do
      expect(page).to have_text '1 bla bla less than a minute'
    end

    within '.breadcrumb' do
      expect(page).to have_text 'Surveys'
      expect(page).to have_text @survey.name
    end
  end

  scenario 'publishing a new version on the base of base version' do
    visit helena.admin_survey_versions_path(@survey)

    fill_in 'Notes', with: 'Luke, I am your father!'

    click_button 'Publish'

    published_version = Helena::Version.last

    within "#helena_#{dom_id(published_version)}" do
      expect(page).to have_text '1 Luke, I am your father! less than a minute'
    end
  end
end
