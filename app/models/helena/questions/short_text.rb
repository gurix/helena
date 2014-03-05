module Helena
  module Questions
    class ShortText < Helena::Question
      include Helena::Concerns::Questions::Validatable
      include Helena::Concerns::Questions::Requirable
    end
  end
end
