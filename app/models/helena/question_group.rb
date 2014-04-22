module Helena
  class QuestionGroup
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    embedded_in :version

    embeds_many :questions, class_name: 'Helena::Question'

    orderable

    field :title, type: String
  end
end
