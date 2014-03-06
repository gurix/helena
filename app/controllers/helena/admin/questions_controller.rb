module Helena
  module Admin
    class QuestionsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_question_group, :load_survey, :add_breadcrumbs
      before_filter :resort, only: [:move_up, :move_down, :create]

      def index
        @questions = @question_group.questions
      end

      def new
        @question = @question_group.questions.new
        @question.labels.build
      end

      def create
        @question = @question_group.questions.new question_params
        @question.position = Helena::Question.maximum_position(@question_group) + 1

        if @question.save
          notify_successful_create_for(@question.code)
          location =  edit_admin_survey_question_group_question_path(@survey, @question_group, @question)
        else
          notify_error
          location = new_admin_survey_question_group_question_path(@survey, @question_group, @question)
          @question.labels.build
        end
        respond_with @question, location: location
      end

      def edit
        @question = @question_group.questions.find(params[:id])
        @question.labels.build

        add_breadcrumb @question.code
      end

      def update
        @question = @question_group.questions.find(params[:id])

        if @question.update_attributes question_params
          notify_successful_update_for(@question.code)
        else
          notify_error
          add_breadcrumb @question.code_was
        end
        respond_with @question, location: edit_admin_survey_question_group_question_path(@survey, @question_group, @question)
      end

      def destroy
        @question = @question_group.questions.find params[:id]
        notify_successful_delete_for(@question.code) if @question.destroy
        respond_with @question, location: admin_survey_question_group_questions_path(@survey, @question_group)
      end

      def move_down
        @question = @question_group.questions.find params[:id]

        if @question.position < Helena::Question.maximum_position(@question_group)
          @question.swap_position @question.position + 1
          notify_successful_update_for(@question.code)
        end

        respond_with @question, location: admin_survey_question_group_questions_path(@survey, @question_group)
      end

      def move_up
        @question = @question_group.questions.find params[:id]
        if @question.position > 1
          @question.swap_position @question.position - 1
          notify_successful_update_for(@question.code)
        end

        respond_with @question, location: admin_survey_question_group_questions_path(@survey, @question_group)
      end

      private

      def load_question_group
        @question_group = Helena::QuestionGroup.find params[:question_group_id]
      end

      def load_survey
        @survey = @question_group.survey
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @question_group.survey.name, admin_survey_question_groups_path(@survey)
        add_breadcrumb @question_group.title, admin_survey_question_group_questions_path(@survey, @question_group)
        add_breadcrumb t('.new') if action_name == 'new' || action_name == 'create'
      end

      def resort
        Helena::Question.resort @question_group
      end

      def labels_attributes
        [:id,
         :position,
         :text,
         :value,
         :_destroy]
      end

      def question_params
        params.require(:question).permit(:question_text,
                                         :code,
                                         :type,
                                         :default_value,
                                         :required,
                                         labels_attributes: labels_attributes ).merge(survey_id: @survey.id)
      end
    end
  end
end
