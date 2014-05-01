module Helena
  class Answer
    include Helena::Concerns::ApplicationModel

    field :code,        type: String
    field :ip_address,  type: String
    field :created_at,  type: DateTime, default: -> { DateTime.now }

    embedded_in :session, inverse_of: :answers

    validates :code, :ip_address, presence: true
    validates :code, uniqueness: true

    def self.cast_value(value)
      if integer?(value)
        value.to_i
      else
        value.to_s
      end
    end

    def self.integer?(str)
      Integer(str) rescue false
    end
  end
end
