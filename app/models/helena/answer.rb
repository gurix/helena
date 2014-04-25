module Helena
  class Answer
    include Helena::Concerns::ApplicationModel

    field :code,        type: String
    field :ip_address,  type: String
    field :created_at,  type: DateTime, default: -> { DateTime.now }

    embedded_in :session, inverse_of: :answers

    validates :code, :ip_address, presence: true
    validates :code, uniqueness: true
  end
end
