module Helena
  class VersionPublisher
    def self.publish(version)
      copied_version = version.dup
      copied_version.survey = version.survey

      copied_version.question_groups << version.question_groups

      copied_version.question_groups.each_with_index do |question_group, index|
        question_group.questions << version.question_groups[index].questions
      end

      adjust_copied_attributes(version, copied_version)
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
  end
end
