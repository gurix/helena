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

      def validate_answers_in(answers)
        errors = {}
        sub_questions.each do |sub_question|
          errors[sub_question.code] = :blank if answers[sub_question.code].blank? && required
        end
        errors
      end
    end
  end
end
