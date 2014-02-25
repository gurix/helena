module Helena
  class QuestionGroup < ActiveRecord::Base
    belongs_to :survey

    after_destroy :resort

    default_scope { order(position: :asc) }

    def swap_position(new_position)
      other_survey = self.class.find_by(position: new_position, survey: survey)
      if other_survey
        other_survey.update_attribute :position, position
        update_attribute :position, new_position
      end
    end

    def self.resort(survey)
      where(survey: survey).each_with_index do | question_group, index |
        question_group.update_attribute(:position, index + 1)
      end
    end

    def self.maximum_position(survey)
      where(survey: survey).maximum(:position) || 0
    end

    private

    def resort
      self.class.resort survey
    end
  end
end
