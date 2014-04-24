module Helena
  class Answer
    include Helena::Concerns::ApplicationModel

    field :code,        type: String
    field :value,       type: String
    field :ip_address,  type: String

    embedded_in :session, inverse_of: :answers

    validates :code, :value, :ip_address, presence: true
    validates :code, uniqueness: true
  end
end
