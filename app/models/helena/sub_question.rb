module Helena
  class SubQuestion
    include Helena::Concerns::ApplicationModel

    field :position, type: Integer
    field :text,     type: String
    field :code,     type: String

    embedded_in :question

    default_scope -> { asc :position }

    validates :text, presence: true
    validates :code, presence: true
  end
end
