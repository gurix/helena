require 'spec_helper'

feature 'Surveys' do
  scenario 'List surveys' do
    create :survey, name: 'My first survey'
    create :survey, name: 'Another cool survey'

    visit helena.surveys_path

    within 'table.surveys' do
      expect(page).to have_text 'My first survey'
      expect(page).to have_text 'Another cool survey'
    end
  end
end
