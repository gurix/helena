module Helena
  module Questions
    class CheckboxMatrix < Helena::Question
      include Helena::Concerns::Questions::Requirable

      def includes_labels?
        true
      end

      def includes_subquestions?
        true
      end
    end
  end
end
