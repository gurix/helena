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

    field :code,          type: String
    field :question_text, type: String

    orderable

    validates :code, presence: true
    validates :code, uniqueness: true # TODO: This should be uniqe scoped over all questions
     # consist of lowercase characters or digits, not starting with a digit or underscore and not ending with an underscore
     # foo_32: correct, 32_foo: incorrect, _bar: incorrect, bar_: incorrect, FooBaar: incorrect
    validates :code, format: { with: /\A[a-z]([-\w]{,498}[a-z\d])?\Z/ }
    validate :uniqueness_of_code

    def includes_labels?
      false
    end

    def includes_subquestions?
      false
    end

    private

    def uniqueness_of_code
      question_codes = question_group.version.question_codes

      if question_codes.count > question_codes.uniq.count
        errors.add :code, :taken, value: code
      end
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
