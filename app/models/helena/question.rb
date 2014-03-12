module Helena
  class Question < ActiveRecord::Base
    TYPES = [
        Helena::Questions::ShortText,
        Helena::Questions::LongText,
        Helena::Questions::StaticText,
        Helena::Questions::RadioGroup,
        Helena::Questions::CheckboxGroup
    ]

    belongs_to :question_group, inverse_of: :questions
    belongs_to :survey, inverse_of: :questions

    has_many :labels, dependent: :destroy
    has_many :sub_questions, dependent: :destroy

    accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels
    accepts_nested_attributes_for :sub_questions, allow_destroy: true, reject_if: :reject_sub_questions

    default_scope { order(position: :asc) }

    validates :question_group, :code, presence: true
    validates :code, uniqueness: { scope: :survey_id }
    validates :version, presence: true

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

    private

    def reject_labels(attributed)
      attributed['text'].blank? &&
          attributed['value'].blank?
    end

    def reject_sub_questions(attributed)
      attributed['code'].blank? &&
          attributed['default_value'].blank? &&
          attributed['question_text'].blank?
    end

    def resort
      self.class.resort question_group
    end
  end
end
