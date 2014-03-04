module Helena
  class Question < ActiveRecord::Base
    TYPES = [Helena::Questions::ShortText]

    belongs_to :question_group, inverse_of: :questions
    belongs_to :survey, inverse_of: :questions

    default_scope { order(position: :asc) }

    validates :question_group, :code, presence: true
    validates :code, uniqueness: { scope: :survey_id }

    serialize :validation_rules

    after_destroy :resort

    def swap_position(new_position)
      other_question = self.class.find_by(position: new_position, question_group: question_group)
      if other_question
        other_question.update_attribute :position, position
        update_attribute :position, new_position
      end
    end

    def self.resort(question_group)
      where(question_group: question_group).each_with_index do | question, index |
        question.update_attribute(:position, index + 1)
      end
    end

    def self.maximum_position(question_group)
      where(question_group: question_group).maximum(:position) || 0
    end

    def required
      rules[:presence].present?
    end

    def required=(value)
      rules[:presence] = (value.to_i == 1)
    end

    def rules
      self.validation_rules ||= {}
    end

    private

    def resort
      self.class.resort question_group
    end
  end
end
