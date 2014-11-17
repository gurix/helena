module Helena
  class VersionPublisher
    def self.publish(version)
      copied_version = create_copied_version_from(version)

      version.question_groups.each do |original_question_group|
        question_group = copied_version.question_groups.create reset_ids(original_question_group.attributes)
        original_question_group.questions.each do |original_question|
          question = question_group.questions.create reset_ids(original_question.attributes)
          question.labels = original_question.labels
          question.sub_questions = original_question.sub_questions
        end
      end
      copied_version
    end

    def self.adjust_copied_attributes(version, copied_version)
      copied_version.version = newest_version_of(version.survey) + 1
      copied_version.created_at = DateTime.now
      copied_version.updated_at = DateTime.now
      copied_version.active = false
      copied_version
    end

    def self.newest_version_of(survey)
      survey.newest_version.version
    end

    def self.create_copied_version_from(version)
      copied_version = Helena::Version.new reset_ids(version.attributes)
      copied_version = adjust_copied_attributes(version, copied_version)
      copied_version.survey_detail = reset_ids(version.survey_detail.attributes) if version.survey_detail
      copied_version.save
      copied_version
    end

    def self.reset_ids(attributes)
      attributes.each do |key, value|
        if key == '_id' && value.is_a?(BSON::ObjectId)
          attributes[key] = BSON::ObjectId.new
        elsif value.is_a?(Hash) || value.is_a?(Array)
          attributes[key] = reset_ids(value)
        end
      end
      attributes
    end
  end
end
