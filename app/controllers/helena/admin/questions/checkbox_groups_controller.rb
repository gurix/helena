module Helena
  module Admin
    module Questions
      class CheckboxGroupsController < Admin::QuestionsController
        def edit
          @question.sub_questions.build
        end

        def update
          if @question.update_attributes question_params
            notify_successful_update_for(@question.code)
          else
            notify_error @question
            add_breadcrumb @question.code_was
          end
          @question.sub_questions.build
          respond_with @question, location: edit_admin_survey_question_group_question_path(@survey, @question_group, @question)
        end

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
