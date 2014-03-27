module Helena
  module Questions
    class RadioGroup < Helena::Question
      include Helena::Concerns::Questions::Validatable
      include Helena::Concerns::Questions::Requirable
      include Helena::Concerns::Questions::ValidatesOneLabel

      def includes_labels?
        true
      end
    end
  end
end
