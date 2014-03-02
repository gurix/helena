module Helena
  module Admin
    class QuestionsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_question_group, :add_breadcrumbs
      before_filter :resort, only: [:move_up, :move_down, :create]

      def create
        add_breadcrumb t('.new')

        @question = @question_group.questions.new question_params
        @question.position = Helena::Question.maximum_position(@question_group) + 1

        if @question.save
          notify_successful_create_for(@question.question_text)
        else
          notify_error
        end
        respond_with @question, location: admin_survey_question_group_questions_path(@question_group.survey, @question_group)
      end

      def destroy
        @question = @question_group.questions.find params[:id]
        notify_successful_delete_for(@question.question_text) if @question.destroy
        respond_with @question, location: admin_survey_question_group_questions_path(@question_group.survey, @question_group)
      end

      def move_down
        @question = @question_group.questions.find params[:id]

        if @question.position < Helena::Question.maximum_position(@question_group)
          @question.swap_position @question.position + 1
          notify_successful_update_for(@question.question_text)
        end

        respond_with @question, location: admin_survey_question_group_questions_path(@question_group.survey, @question_group)
      end

      def move_up
        @question = @question_group.questions.find params[:id]
        if @question.position > 1
          @question.swap_position @question.position - 1
          notify_successful_update_for(@question.question_text)
        end

        respond_with @question, location: admin_survey_question_group_questions_path(@question_group.survey, @question_group)
      end

      private

      def load_question_group
        @question_group = Helena::QuestionGroup.find params[:question_group_id]
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @question_group.survey.name, admin_survey_question_groups_path(@question_group.survey)
        add_breadcrumb @question_group.title, admin_survey_question_group_questions_path(@question_group.survey, @question_group)
      end

      def resort
        Helena::Question.resort @question_group
      end

      def question_params
        params.require(:question).permit(:question_text, :code)
      end
    end
  end
end
