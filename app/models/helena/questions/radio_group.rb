module Helena
  module Questions
    class RadioGroup < Helena::Question
      include Helena::Concerns::Questions::Validatable
      include Helena::Concerns::Questions::Requirable
    end
  end
end
