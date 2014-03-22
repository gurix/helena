module Helena
  module SurveyHelper
    def question_type_translation_for(question_type)
      question_type.to_s.constantize.model_name.human if question_type.present?
    end
  end
end
