module Helena
  class SubQuestion
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    field :text,     type: String
    field :code,     type: String

    embedded_in :question

    orderable

    validates :text, presence: true, uniqueness: true
    validates :code, presence: true, uniqueness: true
  end
end
