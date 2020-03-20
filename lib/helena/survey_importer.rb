require 'yaml'

module Helena
  class SurveyImporter
    attr_accessor :survey

    def initialize(yaml_string)
      @parsed = YAML.load yaml_string # rubocop:disable Security/YAMLLoad

      create_survey
    end

    private

    def create_survey
      @survey = Helena::Survey.find_or_initialize_by @parsed.except('versions')
      return unless @survey.save!
      return unless @parsed['versions']

      @parsed['versions'].each { |parsed_version| create_version parsed_version }
    end

    def create_version(parsed_version)
      version = build_version(parsed_version)
      return unless version.new_record? # We ignore already imported versions
      return unless version.save!
      return unless parsed_version.last['question_groups']

      parsed_version.last['question_groups'].each { |parsed_question_group| create_question_group version, parsed_question_group }
    end

    def create_question_group(version, parsed_question_group)
      question_group = version.question_groups.build parsed_question_group.last.except('questions')
      question_group.position = parsed_question_group.first
      return unless question_group.save!
      return unless parsed_question_group.last['questions']

      parsed_question_group.last['questions'].each { |parsed_question| create_question question_group, parsed_question }
    end

    def create_question(question_group, parsed_question)
      question = question_group.questions.build parsed_question.last
      question.position = parsed_question.first
      question.save!
      question
    end

    def build_version(parsed_version)
      version = @survey.versions.find_or_initialize_by parsed_version.last.except('question_groups', 'survey_detail')
      version.version = parsed_version.first
      version.survey_detail = parsed_version.last['survey_detail']
      version
    end
  end
end
