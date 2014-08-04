module Helena
  class Question
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    CODE_FORMAT = /\A[a-z]([-\w]{,498}[a-z\d])?\Z/

    TYPES = [
      Helena::Questions::ShortText,
      Helena::Questions::LongText,
      Helena::Questions::StaticText,
      Helena::Questions::RadioGroup,
      Helena::Questions::CheckboxGroup,
      Helena::Questions::RadioMatrix
    ]

    embedded_in :question_group, inverse_of: :questions

    embeds_many :labels, class_name: 'Helena::Label'
    embeds_many :sub_questions, class_name: 'Helena::SubQuestion'

    accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels
    accepts_nested_attributes_for :sub_questions, allow_destroy: true, reject_if: :reject_sub_questions

    field :code,          type: String
    field :question_text, type: String

    orderable

    validates :code, presence: true

    # consist of lowercase characters or digits, not starting with a digit or underscore and not ending with an underscore
    # foo_32: correct, 32_foo: incorrect, _bar: incorrect, bar_: incorrect, FooBaar: incorrect
    validates :code, format: { with: CODE_FORMAT }
    validate :uniqueness_of_code

    def includes_labels?
      false
    end

    def includes_subquestions?
      false
    end

    private

    def uniqueness_of_code
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
