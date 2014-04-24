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

    validates :text, presence: true, uniqueness: true
    validates :code, presence: true, uniqueness: true
  end
end
