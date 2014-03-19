module Helena
  module Admin
    module Questions
      class LongTextsController < Admin::QuestionsController
        private

        def question_params
          params.require(:questions_long_text).permit(:question_text,  :code, :type,  :default_value, :required).merge(version_id: @version.id)
        end
      end
    end
  end
end
