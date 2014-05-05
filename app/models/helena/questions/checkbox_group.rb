module Helena
  module Questions
    class CheckboxGroup < Helena::Question
      include Helena::Concerns::Questions::Requirable

      def includes_subquestions?
        true
      end

      def validate_presence_in(answers)
        sub_questions.map { |sub_question| answers[sub_question.code] != 0 }.any?
      end
    end
  end
end
