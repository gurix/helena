module Helena
  class SubQuestion
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    field :text,        type: String
    field :value,       type: String
    field :code,        type: String
    field :preselected, type: Boolean

    embedded_in :question, inverse_of: :sub_questions

    orderable

    validate :uniqueness_of_code
    validates :text, presence: true, uniqueness: true

    def uniqueness_of_code
      question_code_occurences = question.question_group.version.question_code_occurences

      return true if question_code_occurences[code] <= 1

      errors.add(:code, :taken, value: code)
    end
  end
end
