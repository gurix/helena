module Helena
  module Admin
    module Questions
      class ShortTextsController < Admin::QuestionsController
        private

        def question_params
          params.require(:questions_short_text).permit(:question_text,  :code, :type,  :default_value, :required).merge(survey_id: @survey.id)
        end
      end
    end
  end
end
