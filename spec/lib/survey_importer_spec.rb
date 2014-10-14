require 'spec_helper'

describe Helena::SurveyImporter do
  it 'imports a new survey' do
    survey_importer = Helena::SurveyImporter.new File.read(File.dirname(__FILE__) + '/../../db/swls_survey.en.yml')
    survey = survey_importer.survey

    expect(survey).to have_exactly(1).versions
    expect(survey.versions.first).to have_exactly(1).question_groups
    expect(survey.versions.first.question_groups.first).to have_exactly(1).questions
    expect(survey.versions.first.question_groups.first.questions.first).to have_exactly(7).labels
    expect(survey.versions.first.question_groups.first.questions.first).to have_exactly(5).sub_questions
  end
end
