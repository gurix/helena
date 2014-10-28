require 'spec_helper'

feature 'Session management' do
  let(:survey) { create :survey, name: 'dummy' }
  let(:base_version) { survey.versions.create version: 0 }
  let!(:first_question_group) { base_version.question_groups.create title: 'Page 1' }

  background do
    base_version.survey_detail = build :survey_detail, title: 'Dummy Survey', description: 'Leucadendron is a plants in the family Proteaceae.'
  end

  scenario 'edits a session' do
    short_text_question  = build :short_text_question, code: 'a_name', question_text: "What's your name?"
    first_question_group.questions << short_text_question

    long_text_question  = build :long_text_question, code: 'selfdescription', question_text: 'Give a brief description of yourself'
    first_question_group.questions << long_text_question

    second_question_group = base_version.question_groups.create title: 'Page 2', allow_to_go_back: true

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

    third_question_group = base_version.question_groups.create title: 'Page 3', allow_to_go_back: true

    satisfaction_matrix = build :radio_matrix_question, code:          :satisfaction,
                                                        question_text: 'Below are five statements with which you may agree or disagree.',
                                                        required:      true,
                                                        position:      1

    satisfaction_matrix.labels << build(:label, position: 1, text: 'Strongly Disagree', value: 1)
    satisfaction_matrix.labels << build(:label, position: 2, text: 'Disagree', value: 2)
    satisfaction_matrix.labels << build(:label, position: 3, text: 'Slightly Disagree', value: 3)
    satisfaction_matrix.labels << build(:label, position: 4, text: 'Neither Agree or Disagree', value: 4)
    satisfaction_matrix.labels << build(:label, position: 5, text: 'Slightly Agree', value: 5)
    satisfaction_matrix.labels << build(:label, position: 6, text: 'Agree', value: 6)
    satisfaction_matrix.labels << build(:label, position: 7, text: 'Strongly Agree', value: 7)

    satisfaction_matrix.sub_questions << build(:sub_question, text: 'In most ways my life is close to my ideal.', code: 'life_is_ideal', position: 1)
    satisfaction_matrix.sub_questions << build(:sub_question, text: 'The conditions of my life are excellent.', code: 'condition', position: 2)
    satisfaction_matrix.sub_questions << build(:sub_question, text: 'I am satisfied with life.', code: 'satisfied_with_life', position: 3)
    satisfaction_matrix.sub_questions << build(:sub_question, text:     'So far I have gotten the important things I want in life.',
                                                              code:     'important_things',
                                                              position: 4)
    satisfaction_matrix.sub_questions << build(:sub_question, text: 'If I could live my life over, I would change almost nothing.',
                                                              code: 'nothing_to_change',
                                                              position: 5)

    third_question_group.questions << satisfaction_matrix
    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'Dummy Survey'
    expect(page).to have_content 'Page 1'
    expect(page).to have_content "What's your name?"
    expect(page).to have_content 'Give a brief description of yourself'

    expect(page).not_to have_link 'Back'

    fill_in 'session_answers_a_name', with: 'Hans'
    fill_in 'session_answers_selfdescription', with: 'I am a proud man living in middle earth. Everybody is laughing at me because I do not have hairy feets.'

    expect { click_button 'Next' }.to change { session.reload.answers.count }.from(0).to(2)
    expect(session.reload.last_question_group_id).to eq second_question_group.id

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

    expect(page).to have_link 'Back', href: helena.edit_session_path(session.token, question_group: version.question_groups.find_by(position: 1))
    expect { click_button 'Next' }.to change { session.reload.answers.count }.from(2).to(6)
    expect(session.reload.last_question_group_id).to eq third_question_group.id

    expect(page).to have_content 'Page 3'

    expect(page).to have_content 'Below are five statements with which you may agree or disagree.'

    expect(page).to have_content 'Strongly Disagree'
    expect(page).to have_content 'Disagree'
    expect(page).to have_content 'Slightly Disagree'
    expect(page).to have_content 'Neither Agree or Disagree'
    expect(page).to have_content 'Slightly Agree'
    expect(page).to have_content 'Agree'
    expect(page).to have_content 'Strongly Agree'

    expect(page).to have_content 'In most ways my life is close to my ideal.'
    expect(page).to have_content 'The conditions of my life are excellent.'
    expect(page).to have_content 'I am satisfied with life.'
    expect(page).to have_content 'So far I have gotten the important things I want in life.'
    expect(page).to have_content 'If I could live my life over, I would change almost nothing.'

    choose('session_answers_life_is_ideal_1')
    choose('session_answers_important_things_2')
    choose('session_answers_condition_4')
    choose('session_answers_nothing_to_change_5')
    choose('session_answers_satisfied_with_life_7')

    expect(page).to have_link 'Back', href: helena.edit_session_path(session.token, question_group: version.question_groups.find_by(position: 2))
    expect { click_button 'Save' }.to change { session.reload.answers.count }.from(6).to(11)
  end

  scenario 'a user resumes the questionary and starts with ne first unfinished question group' do
    second_question_group = base_version.question_groups.create title: 'Page 2'

    session = survey.sessions.create version_id: base_version.id, token: 'abcdefg'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'Page 1'
    click_button 'Next'

    expect(session.reload.last_question_group_id).to eq second_question_group.id

    visit helena.edit_session_path(session.token)
    expect(page).to have_content 'Page 2'
  end

  scenario 'does not save an empty short text field when required' do
    short_text_question  = build :short_text_question, code: 'a_name', question_text: "What's your name?", required: true
    first_question_group.questions << short_text_question

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content "What's your name? *"
    expect(page).to have_content '* indicates required fields'
    expect { click_button 'Save' }.not_to change { session.reload.answers.count }
    expect(page).to have_content("can't be blank")
  end

  scenario 'does not display "* indicates required fields" when no required fields are in question group' do
    short_text_question  = build :short_text_question, code: 'a_name', question_text: "What's your name?", required: false
    first_question_group.questions << short_text_question

    session = survey.sessions.create version_id: base_version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content "What's your name?"
    expect(page).not_to have_content '* indicates required fields'
  end

  scenario 'does not save an empty long text field when required' do
    long_text_question  = build :long_text_question, code: 'selfdescription', question_text: 'Give a brief description of yourself', required: true
    first_question_group.questions << long_text_question

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'Give a brief description of yourself *'
    expect { click_button 'Save' }.not_to change { session.reload.answers.count }
    expect(page).to have_content("can't be blank")
  end

  scenario 'does not save a non selected radio group when required' do
    all_and_everything = build :radio_group_question, code:           :all_and_everything,
                                                      question_text:  'What is the answer to the Ultimate Question of Life, the Universe, and Everything?',
                                                      required:       true

    all_and_everything.labels << build(:label, value: 'norris')
    all_and_everything.labels << build(:label, value: 'god')
    all_and_everything.labels << build(:label, value: 42)
    all_and_everything.labels << build(:label, value: 'mom')

    first_question_group.questions << all_and_everything

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'What is the answer to the Ultimate Question of Life, the Universe, and Everything? *'
    expect { click_button 'Save' }.not_to change { session.reload.answers.count }
    expect(page).to have_content("can't be blank")
  end

  scenario 'does not save when no subquestion of a checkbox group is selected if required' do
    food_allergy = build :checkbox_group_question, code:           :food_allergy,
                                                   question_text:  'What kind of food allergy do you have?',
                                                   required:       true

    food_allergy.sub_questions << build(:sub_question, text: 'Garlic', code: 'garlic')
    food_allergy.sub_questions << build(:sub_question, text: 'Oats', code: 'oat')
    food_allergy.sub_questions << build(:sub_question, text: 'Meat', code: 'meat')

    first_question_group.questions << food_allergy

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'What kind of food allergy do you have? *'
    expect { click_button 'Save' }.to change { session.reload.answers.map(&:value) }.from([]).to([0, 0, 0])
    expect(page).to have_content("can't be blank")
  end

  scenario 'saves when subquestion of a checkbox group is selected if required' do
    food_allergy = build :checkbox_group_question, code:           :food_allergy,
                                                   question_text:  'What kind of food allergy do you have?',
                                                   required:       true

    food_allergy.sub_questions << build(:sub_question, text: 'Garlic', code: 'garlic')
    food_allergy.sub_questions << build(:sub_question, text: 'Oats', code: 'oat')
    food_allergy.sub_questions << build(:sub_question, text: 'Meat', code: 'meat')

    first_question_group.questions << food_allergy

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'What kind of food allergy do you have? *'
    check('Oats')
    expect { click_button 'Save' }.to change { session.reload.answers.count }.from(0).to(3)
    expect(page).not_to have_content("can't be blank")
  end

  scenario 'does not save when radio matrix is filled out completely if required' do
    satisfaction_matrix = build :radio_matrix_question, code:          :satisfaction,
                                                        question_text: 'Below are five statements with which you may agree or disagree.',
                                                        required:      true

    satisfaction_matrix.labels << build(:label, value: 1)
    satisfaction_matrix.labels << build(:label, value: 2)
    satisfaction_matrix.labels << build(:label, value: 3)
    satisfaction_matrix.labels << build(:label, value: 4)
    satisfaction_matrix.labels << build(:label, value: 5)
    satisfaction_matrix.labels << build(:label, value: 6)
    satisfaction_matrix.labels << build(:label, value: 7)

    satisfaction_matrix.sub_questions << build(:sub_question, code: 'life_is_ideal')
    satisfaction_matrix.sub_questions << build(:sub_question, code: 'condition')
    satisfaction_matrix.sub_questions << build(:sub_question, code: 'satisfied_with_life')
    satisfaction_matrix.sub_questions << build(:sub_question, code: 'important_things')
    satisfaction_matrix.sub_questions << build(:sub_question, code: 'nothing_to_change')

    first_question_group.questions << satisfaction_matrix

    version = Helena::VersionPublisher.publish(base_version)
    version.save

    session = survey.sessions.create version_id: version.id, token: 'abc'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'Below are five statements with which you may agree or disagree. *'

    choose('session_answers_satisfied_with_life_3')

    expect { click_button 'Save' }.to change { session.reload.answers.count }.from(0).to(1)

    expect(page).to have_content("can't be blank")
  end

  scenario 'Allows to define whether a user an jump back for each question group seperately' do
    second_question_group = base_version.question_groups.create title: 'Page 2', allow_to_go_back: true
    base_version.question_groups.create title: 'Page 3', allow_to_go_back: false

    session = survey.sessions.create version_id: base_version.id, token: 'abcdefg'

    visit helena.edit_session_path(session.token)

    expect(page).to have_content 'Page 1'
    expect(page).not_to have_link 'Back'

    click_button 'Next'

    expect(page).to have_link 'Back', href: helena.edit_session_path(session.token, question_group: second_question_group.previous_item)
    expect(page).to have_content 'Page 2'

    click_button 'Next'

    expect(page).not_to have_link 'Back'
  end
end
