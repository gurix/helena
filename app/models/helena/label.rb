module Helena
  class Label
    include Helena::Concerns::ApplicationModel

    field :position,    type: Integer, default: 1
    field :text,        type: String
    field :value,       type: String
    field :preselected, type: Boolean, default: false

    embedded_in :question, inverse_of: :labels

    default_scope -> { asc :position }

    validates :text, presence: true
    validates :value, presence: true
    validates :value, uniqueness: { scope: :question_id }
  end
end
