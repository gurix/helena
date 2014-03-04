module Helena
  module SurveyHelper
    def question_type_translation_for(question_type)
      question_type_name = "#{question_type}"

      if question_type_name.present?
        question_type_name = question_type_name.split('::').last.underscore
        translate "question_types.#{question_type_name}"
      end
    end
  end
end
