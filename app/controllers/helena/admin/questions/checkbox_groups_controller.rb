module Helena
  module Admin
    module Questions
      class CheckboxGroupsController < Admin::QuestionsController
        private

        def sub_questions_attributes
          [:id, :position, :code, :question_text, :default_value, :preselected, :_destroy]
        end

        def question_params
          params.require(:questions_checkbox_group).permit(:question_text,
                                                           :code,
                                                           :type,
                                                           :required,
                                                           sub_questions_attributes: sub_questions_attributes).merge(survey_id: @survey.id)
        end
      end
    end
  end
end
