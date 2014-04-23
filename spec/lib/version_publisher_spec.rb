require 'spec_helper'

describe Helena::VersionPublisher do
  let!(:survey) { create :survey }
  let!(:base_version) { survey.versions.create version: 42 }
  let!(:survey_detail) { base_version.survey_detail = build :survey_detail }
  let!(:question_group) { base_version.question_groups.create }
  let!(:question) { question_group.questions.create code: 'abc' }
  let!(:label) { question.labels.create text: 'xyz', value: 'asdf' }
  let!(:sub_question) { question.sub_questions.create text: 'ymca', code: 'cde' }

  it 'creates a new version' do
    new_version = Helena::VersionPublisher.publish(base_version)

    expect(new_version.version).to eq 43
    expect(new_version.survey_detail).to be_a Helena::SurveyDetail
    expect(new_version.question_groups).to have(1).item
    expect(new_version.question_groups.first.questions).to have(1).item
    expect(new_version.question_groups.first.questions.first.labels).to have(1).item
    expect(new_version.question_groups.first.questions.first.sub_questions).to have(1).item
  end
end
