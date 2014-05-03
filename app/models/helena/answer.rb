module Helena
  class Answer
    include Helena::Concerns::ApplicationModel

    field :code,        type: String
    field :ip_address,  type: String
    field :created_at,  type: DateTime, default: -> { DateTime.now }

    embedded_in :session, inverse_of: :answers

    validates :code, :ip_address, presence: true
    validates :code, uniqueness: true

    def self.build_generic(code, value, ip_address)
      value = cast_value(value)
      answer_class_for(value).new(code: code, value: value, ip_address: ip_address)
    end

    def self.answer_class_for(value)
      case value
      when Fixnum
        Helena::IntegerAnswer
      when TrueClass
        Helena::BooleanAnswer
      when FalseClass
        Helena::BooleanAnswer
      when String
        Helena::StringAnswer
      end
    end

    def self.cast_value(value)
      if value == 'true'
        true
      elsif value == 'false'
        false
      elsif integer?(value)
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
