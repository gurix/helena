module Helena
  class QuestionGroup
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    belongs_to :version

    has_many :questions, inverse_of: :question_group, class_name: 'Helena::Question', dependent: :destroy,  autosave: true

    orderable scope: :version

    field :title, type: String
    field :allow_to_go_back, type: Boolean

    def question_codes
      questions.map { |question| [question.code] + question.sub_questions.map(&:code) }.flatten
    end
  end
end
