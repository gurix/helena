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
      Helena::Questions::BipolarRadioMatrix
    ].freeze

    belongs_to :question_group, inverse_of: :questions

    embeds_many :labels, class_name: 'Helena::Label', cascade_callbacks: true
    embeds_many :sub_questions, class_name: 'Helena::SubQuestion', cascade_callbacks: true

    accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels
    accepts_nested_attributes_for :sub_questions, allow_destroy: true, reject_if: :reject_sub_questions

    field :code,          type: String
    field :question_text, type: String

    orderable scope: :question_group

    validates :code, presence: true
    validate :uniqueness_of_code

    def includes_labels?
      false
    end

    def includes_subquestions?
      false
    end

    private

    def uniqueness_of_code
      return unless question_group

      question_code_occurences = question_group.version.question_code_occurences
      errors.add :code, :taken if question_code_occurences[code] > 1
    end

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
