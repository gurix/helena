module Helena
  class SubQuestion
    include Helena::Concerns::ApplicationModel

    field :position, type: Integer, default: 1
    field :text,     type: String
    field :code,     type: String

    embedded_in :question, inverse_of: :sub_questions

    default_scope -> { asc :position }

    validates :question, presence: true
    validates :text, presence: true
    validates :text, uniqueness: { scope: :question_id }
    validates :code, presence: true
    validates :code, uniqueness: { scope: :question_id }
  end
end
