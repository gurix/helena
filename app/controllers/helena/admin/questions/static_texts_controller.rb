module Helena
  module Admin
    module Questions
      class StaticTextsController < Admin::QuestionsController
        private

        def question_params
          params.require(:questions_static_text).permit(:question_text,  :code, :type,  :default_value).merge(version_id: @version.id)
        end
      end
    end
  end
end
