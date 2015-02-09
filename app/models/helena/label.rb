module Helena
  class Label
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    field :text,        type: String
    field :value,       type: String
    field :preselected, type: Boolean, default: false

    embedded_in :question, inverse_of: :labels

    orderable

    validates :value, presence: true
    validates :value, uniqueness: true
  end
end
