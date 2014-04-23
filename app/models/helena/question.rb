module Helena
  class Question
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

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

    # embeds_many :labels, class_name: 'Helena::Label'
#     embeds_many :sub_questions, class_name: 'Helena::SubQuestion'
#
#     accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels
#     accepts_nested_attributes_for :sub_questions, allow_destroy: true, reject_if: :reject_sub_questions

    field :code,          type: String
    field :question_text, type: String

    orderable

    validates :code, presence: true
    validates :code, uniqueness: true # TODO: This should be uniqe scoped over all questions

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
  end
end
