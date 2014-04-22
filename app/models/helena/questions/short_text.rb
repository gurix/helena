module Helena
  module Questions
    class ShortText < Helena::Question
      include Helena::Concerns::Questions::Validatable
      include Helena::Concerns::Questions::Requirable

       field :default_value, type: String
    end
  end
end
