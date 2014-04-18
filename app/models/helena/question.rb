module Helena
  class Question
    include Helena::Concerns::ApplicationModel

    field :code,          type: String
    field :question_text, type: String
    field :position,      type: Integer, default: 1
    field :validation_rules, type: Hash

    TYPES = [
      Helena::Questions::ShortText,
      Helena::Questions::LongText,
      Helena::Questions::StaticText,
      Helena::Questions::RadioGroup,
      Helena::Questions::CheckboxGroup,
      Helena::Questions::RadioMatrix,
      Helena::Questions::CheckboxMatrix
    ]

    embedded_in :question_group, inverse_of: :questions

    embeds_many :labels, class_name: 'Helena::Label'
    embeds_many :sub_questions, class_name: 'Helena::SubQuestion'

    accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels
    accepts_nested_attributes_for :sub_questions, allow_destroy: true, reject_if: :reject_sub_questions

    default_scope -> { asc :position }

    validates :question_group, :code, presence: true
    validates :code, uniqueness: true

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

    def includes_labels?
      false
    end

    def includes_subquestions?
      false
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
