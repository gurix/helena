module Helena
  module Questions
    class CheckboxGroup < Helena::Question
      include Helena::Concerns::Questions::Requirable

      def includes_subquestions?
        true
      end
    end
  end
end
