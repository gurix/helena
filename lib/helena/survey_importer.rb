require 'yaml'

module Helena
  class SurveyImporter
    attr_accessor :survey

    def initialize(yaml_string)
      @parsed = YAML.load yaml_string

      create_survey
    end

    private

    def create_survey
      @survey = Helena::Survey.new @parsed.except('versions')
      if @survey.save
        @parsed['versions'].each do |parsed_version|
          create_version parsed_version
        end
      else
        raise_error @survey
      end
    end

    def create_version(parsed_version)
      version = @survey.versions.build parsed_version.last.except('question_groups')
      version.version = parsed_version.first
      version.survey_detail = parsed_version.last['survey_detail']

      if version.save
        parsed_version.last['question_groups'].each do |parsed_question_group|
          create_question_group version, parsed_question_group
        end
      else
        raise_error version
      end
    end

    def create_question_group(version, parsed_question_group)
      question_group = version.question_groups.build parsed_question_group.last.except('questions')
      question_group.position = parsed_question_group.first
      if question_group.save
        parsed_question_group.last['questions'].each do |parsed_question|
          create_question question_group, parsed_question
        end
      else
        raise_error question_group
      end
    end

    def create_question(question_group, parsed_question)
      question = question_group.questions.build parsed_question.last
      question.position = parsed_question.first
      raise_error(question) unless question.save
      question
    end

    def raise_error(object)
      @survey.delete
      fail object.errors.messages.to_s
    end
  end
end
