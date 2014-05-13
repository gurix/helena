module Helena
  module Questions
    class CheckboxGroup < Helena::Question
      include Helena::Concerns::Questions::Requirable

      def includes_subquestions?
        true
      end

      def validate_answers_in(answers)
        errors = {}
        errors[code] = :blank if sub_questions.map { |sub_question| answers[sub_question.code] == 0 }.all? && required
        errors
      end
    end
  end
end
