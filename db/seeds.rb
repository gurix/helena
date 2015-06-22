require 'factory_girl'
require 'faker'
require 'database_cleaner'
require 'helena/survey_importer'

include FactoryGirl::Syntax::Methods

puts 'Cleaning database ...'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

puts 'Seeding surveys ...'

def create_satisfaction_scale_survey
  survey_importer = Helena::SurveyImporter.new File.read(File.dirname(__FILE__) + '/swls_survey.en.yml')
  generate_sessions(survey_importer.survey, survey_importer.survey.newest_version)
end

def publish(version)
  published_version = Helena::VersionPublisher.publish(version)
  published_version.notes = Faker::Lorem.paragraph(1)
  published_version.save
  published_version
end
# rubocop:disable Metrics/MethodLength
def generate_sessions(survey, version)
  3.times { survey.sessions << build(:session, version: version, updated_at: DateTime.now - rand(999), completed: false) }

  3.times do
    session = build :session, version: version, updated_at: DateTime.now - rand(999), completed: true
    version.question_groups.map(&:questions).flatten.each do |question|
      case question
      when Helena::Questions::ShortText
        session.answers << build(:string_answer, code: question.code, value: Faker::Skill.tech_skill)
      when Helena::Questions::LongText
        session.answers << build(:string_answer, code: question.code, value: Faker::Skill.tech_skill)
      when Helena::Questions::RadioGroup
        session.answers << Helena::Answer.build_generic(question.code, question.labels.sample.value, Faker::Internet.ip_v4_address)
      when Helena::Questions::CheckboxGroup
        question.sub_questions.sample(2).each do |sub_question|
          session.answers << Helena::Answer.build_generic(sub_question.code, sub_question.value, Faker::Internet.ip_v4_address)
        end
      when Helena::Questions::RadioMatrix
        question.sub_questions.each do |sub_question|
          session.answers << Helena::Answer.build_generic(sub_question.code, question.labels.sample.value, Faker::Internet.ip_v4_address)
        end
      end
    end
    survey.sessions << session
  end
end
# rubocop:enable Metrics/MethodLength

create_satisfaction_scale_survey
