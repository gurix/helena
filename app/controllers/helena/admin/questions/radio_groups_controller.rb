module Helena
  module Admin
    module Questions
      class RadioGroupsController < Admin::QuestionsController
        def edit
          @question.labels.build
        end

        def update
          if @question.update_attributes question_params
            notify_successful_update_for(@question.code)
          else
            notify_error @question
            add_breadcrumb @question.code_was
          end
          @question.labels.build
          respond_with @question, location: edit_admin_survey_question_group_question_path(@survey, @question_group, @question)
        end

        private

        def labels_attributes
          [:id, :position, :text, :value, :preselected, :_destroy]
        end

        def question_params
          params.require(:questions_radio_group).permit(:question_text,
                                                        :code,
                                                        :type,
                                                        :required,
                                                        labels_attributes: labels_attributes).merge(survey_id: @survey.id)
        end
      end
    end
  end
end
