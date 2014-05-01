require 'spec_helper'

feature 'Session management' do
  scenario 'edits a session', driver: :selenium do
    survey = create :survey, name: 'dummy'
    base_version = survey.versions.create version: 0
    base_version.survey_detail = build :survey_detail, title: 'Dummy Survey'

    first_question_group = build(:question_group, title: 'Page 1', position: 1)
    base_version.question_groups << first_question_group

    short_text_question  = build :short_text_question, code: 'a_name', question_text: "What's your name?"
    first_question_group.questions << short_text_question

    long_text_question  = build :long_text_question, code: 'selfdescription', question_text: 'Give a brief description of yourself'
    first_question_group.questions << long_text_question

    second_question_group = build(:question_group, title: 'Page 2', position: 2)
    base_version.question_groups << second_question_group

    all_and_everything = build :radio_group_question, code:           :all_and_everything,
                                                      question_text:  'What is the answer to the Ultimate Question of Life, the Universe, and Everything?',
                                                      position:       1

    all_and_everything.labels << build(:label, position: 1, text: 'Just Chuck Norris knows it', value: 'norris')
    all_and_everything.labels << build(:label, position: 2, text: 'God', value: 'god')
    all_and_everything.labels << build(:label, position: 3, text: '42', value: 42)
    all_and_everything.labels << build(:label, position: 4, text: 'Your mom', value: 'mom', preselected: :true)

    second_question_group.questions << all_and_everything

    food_allergy = build :checkbox_group_question, code:           :food_allergy,
                                                   question_text:  'What kind of food allergy do you have?',
                                                   position:       2

    food_allergy.sub_questions << build(:sub_question, text: 'Garlic', code: 'garlic', position: 1, preselected: true)
    food_allergy.sub_questions << build(:sub_question, text: 'Oats', code: 'oat', position: 2)
    food_allergy.sub_questions << build(:sub_question, text: 'Meat', code: 'meat', position: 3)

    second_question_group.questions << food_allergy

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_survey_session_path(survey, session)

    expect(page).to have_content 'Dummy Survey'
    expect(page).to have_content 'Page 1'
    expect(page).to have_content "What's your name?"
    expect(page).to have_content 'Give a brief description of yourself'

    fill_in 'session_answers_a_name', with: 'Hans'
    fill_in 'session_answers_selfdescription', with: 'I am a proud man living in middle earth. Everybody is laughing at me because I do not have hairy feets.'

    expect { click_button 'Next' }.to change { session.reload.answers.count }.from(0).to(2)

    expect(page).to have_content 'Page 2'

    expect(page).to have_content 'What is the answer to the Ultimate Question of Life, the Universe, and Everything?'
    expect(page).to have_content 'Just Chuck Norris knows it'
    expect(page).to have_content 'God'
    expect(page).to have_content '42'
    expect(page).to have_content 'Your mom'

    choose('42')

    expect(page).to have_content 'What kind of food allergy do you have?'
    expect(page).to have_content 'Garlic'
    expect(page).to have_content 'Oats'
    expect(page).to have_content 'Meat'

    uncheck('Garlic')
    check('Oats')
    check('Meat')

    expect { click_button 'Save' }.to change { session.reload.answers.count }.from(2).to(6)
    binding.pry
  end
end
