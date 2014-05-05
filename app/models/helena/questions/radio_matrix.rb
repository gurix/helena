module Helena
  module Questions
    class RadioMatrix < Helena::Question
      include Helena::Concerns::Questions::Requirable
      include Helena::Concerns::Questions::ValidatesOneLabel

      def includes_labels?
        true
      end

      def includes_subquestions?
        true
      end

      def validate_presence_in(answers)
        sub_questions.map { |sub_question| answers[sub_question.code] }.any?
      end
    end
  end
end
