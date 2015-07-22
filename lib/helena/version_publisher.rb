module Helena
  class VersionPublisher
    def self.publish(version)
      copied_version = build_copied_version_from(version)

      version.question_groups.each do |original_question_group|
        question_group = copied_version.question_groups.build original_question_group.clone.attributes
        original_question_group.questions.each do |original_question|
          question = question_group.questions.build original_question.clone.attributes
          question.labels = original_question.labels
          question.sub_questions = original_question.sub_questions
        end
      end
      copied_version
    end

    def self.adjust_copied_attributes(version, copied_version)
      copied_version.version = newest_version_of(version.survey) + 1
      copied_version.survey_detail = version.survey_detail.attributes if version.survey_detail
      copied_version.created_at = DateTime.now
      copied_version.updated_at = DateTime.now
      copied_version.active = false
      copied_version
    end

    def self.newest_version_of(survey)
      survey.newest_version.version
    end

    def self.build_copied_version_from(version)
      copied_version = version.clone
      adjust_copied_attributes(version, copied_version)
    end
  end
end
