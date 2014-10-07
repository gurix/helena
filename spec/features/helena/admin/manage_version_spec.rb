require 'spec_helper'
include ActionView::RecordIdentifier

feature 'Version management' do
  background do
    @survey = create :survey
    @baseversion = @survey.versions.create version: 0
  end

  scenario 'lists all versions of a survey' do
    published_version = Helena::VersionPublisher.publish @baseversion
    published_version.notes = 'bla bla'
    published_version.save

    visit helena.admin_survey_versions_path(@survey)

    within "#helena_#{dom_id published_version}" do
      expect(page).to have_text '1 bla bla 0 less than a minute'
    end

    within '.breadcrumb' do
      expect(page).to have_text 'Surveys'
      expect(page).to have_text @survey.name
    end
  end

  scenario 'publishing a new version on the base of base version', pending: true do

    visit helena.new_admin_survey_version_path @survey

    expect(find_field('version_session_report').value).to have_content '{{ survey_title }}'

    fill_in 'Notes', with: 'Luke, I am your father!'
    fill_in 'version_session_report', with: 'Foo Bar'

    expect { click_button 'Save' }.to change { @survey.reload.versions.count }.by(1)

    expect(@survey.reload.versions.last.session_report).to eq 'Foo Bar'

    visit helena.new_admin_survey_version_path @survey

    expect(find_field('version_session_report').value).to have_content 'Foo Bar'
  end

  scenario 'changing the session report for a version' do
    published_version = Helena::VersionPublisher.publish @baseversion

    visit helena.edit_admin_survey_version_path(@survey, published_version)

    fill_in 'Notes', with: 'Michael Knight, a lone crusader in a dangerous world. The world of the Knight Rider.'
    fill_in 'version_session_report', with: 'A Man, a Car'

    click_button 'Save'

    expect(published_version.reload.notes).to eq 'Michael Knight, a lone crusader in a dangerous world. The world of the Knight Rider.'
    expect(published_version.reload.session_report).to eq 'A Man, a Car'
  end

  scenario 'deletes a version' do
    published_version = Helena::VersionPublisher.publish @baseversion

    visit helena.admin_survey_versions_path @survey

    within "#helena_#{dom_id published_version }" do
      expect { click_link 'Delete' }.to change { @survey.reload.versions.count }.by(-1)
    end
  end
end
