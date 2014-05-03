module Helena
  class QuestionGroup
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    embedded_in :version

    embeds_many :questions, class_name: 'Helena::Question'

    orderable

    field :title, type: String

    def question_codes
      questions.map { |question| [question.code] +  question.sub_questions.map(&:code) }.flatten
    end
  end
end
