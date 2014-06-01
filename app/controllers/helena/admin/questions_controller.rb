module Helena
  module Admin
    class QuestionsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_resources, :add_breadcrumbs
      before_filter :load_question, only: [:edit, :update, :destroy, :move_up, :move_down]

      def index
        @questions = @question_group.questions.asc :position
      end

      def new
        @question = @question_group.questions.new
      end

      def create
        @question = @question_group.questions.new question_params

        if @question.save
          notify_successful_create_for(@question.code)
          location = [:admin, @survey, @question_group, :questions]
        else
          notify_error(@question)
          location = [:new, :admin, @survey, @question_group, @question]
        end
        respond_with @question, location: location
      end

      def edit
        add_ressources
      end

      def update
        if @question.update_attributes question_params
          notify_successful_update_for(@question.code)
        else
          notify_error @question
          add_breadcrumb @question.code_was
        end
        add_ressources
        respond_with @question, location: [:edit, :admin, @survey, @question_group, @question]
      end

      def destroy
        notify_successful_delete_for(@question.code) if @question.destroy
        respond_with @question, location: admin_survey_question_group_questions_path(@survey, @question_group)
      end

      def move_up
        @question.move_to! :higher
        respond_with @question, location: admin_survey_question_group_questions_path(@survey, @question_group)
      end

      def move_down
        @question.move_to! :lower
        respond_with @question, location: admin_survey_question_group_questions_path(@survey, @question_group)
      end

      private

      def load_resources
        @survey = Helena::Survey.find params['survey_id']
        @version = @survey.versions.find_by(version: 0)
        @question_group = @version.question_groups.find params[:question_group_id]
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @survey.name, admin_survey_question_groups_path(@survey)
        add_breadcrumb @question_group.title, admin_survey_question_group_questions_path(@survey, @question_group)
        add_breadcrumb t('helena.admin.questions.new') if action_name == 'new' || action_name == 'create'
      end

      def question_params
        required_param.permit(permited_params + [:question_text,  :code, :_type])
      end

      def required_param
        param_name = self.class == Helena::Admin::QuestionsController ? :question : "questions_#{controller_name.singularize}"
        params.require(param_name)
      end

      def permited_params
        []
      end

      def load_question
        @question = @question_group.questions.find(params[:id])
        add_breadcrumb @question.code
      end

      def add_ressources
      end

      def labels_attributes
        [:id, :position, :text, :value, :preselected, :_destroy]
      end

      def sub_questions_attributes
        [:id, :position, :code, :text, :value, :preselected, :_destroy]
      end
    end
  end
end
