module Helena
  module Admin
    module Questions
      class CheckboxGroupsController < Admin::QuestionsController
        private

        def sub_questions_attributes
          [:id, :position, :code, :text, :value, :preselected, :_destroy]
        end

        def question_params
          params.require(:questions_checkbox_group).permit(:question_text,
                                                           :code,
                                                           :type,
                                                           :required,
                                                           sub_questions_attributes: sub_questions_attributes).merge(survey_id: @survey.id)
        end

        def add_ressources
          @question.sub_questions.build
        end
      end
    end
  end
end
