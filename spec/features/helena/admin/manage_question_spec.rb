require 'spec_helper'

feature 'Question management' do

  let!(:question_group) { create :question_group }

  scenario 'lists all question groups of a certain survey' do
    create :question, question_text: 'Who are you?', question_group: question_group, position: 1
    create :question, question_text: 'Imagine an inivisible pony. What color has ist?', question_group: question_group, position: 2

    visit helena.admin_survey_question_group_questions_path(question_group.survey, question_group)

    within '#helena_question_1' do
      expect(page).to have_text 'Who are you?'
    end

    within '#helena_question_2' do
      expect(page).to have_text 'Imagine an inivisible pony. What color has ist?'
    end

    within '.breadcrumb' do
      expect(page).to have_link'Surveys', href: helena.admin_surveys_path
      expect(page).to have_link question_group.survey.name, href: helena.admin_survey_question_groups_path(question_group.survey)
      expect(page).to have_text question_group.title
    end
  end
end
