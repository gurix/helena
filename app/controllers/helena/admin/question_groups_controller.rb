require_dependency 'helena/application_controller'

module Helena
  module Admin
    class QuestionGroupsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_resources, :add_breadcrumbs
      before_filter :find_question_group, only: [:edit, :destroy, :move_up, :move_down]
      before_filter :resort, only: [:move_up, :move_down, :create]

      def index
        @question_groups = @version.question_groups
      end

      def new
        add_breadcrumb t('.new')
        @question_group = @version.question_groups.new
      end

      def create
        add_breadcrumb t('.new')

        @question_group = @version.question_groups.new question_group_params
        @question_group.position = Helena::QuestionGroup.maximum_position + 1

        if @question_group.save
          notify_successful_create_for(@question_group.title)
        else
          notify_error
        end
        respond_with @question_group, location: admin_survey_question_groups_path(@survey)
      end

      def edit
        add_breadcrumb @question_group.title
      end

      def update
        @question_group = @version.question_groups.find(params[:id])

        if @question_group.update_attributes question_group_params
          notify_successful_update_for(@question_group.title)
        else
          notify_error
          add_breadcrumb @question_group.title_was
        end
        respond_with @question_group, location: admin_survey_question_groups_path(@survey)
      end

      def destroy
        notify_successful_delete_for(@question_group.title) if @question_group.destroy
        respond_with @question_group, location: admin_survey_question_groups_path(@survey)
      end

      def move_up
        if @question_group.reload.position > 1
          @question_group.swap_position @question_group.position - 1
          notify_successful_update_for(@question_group.title)
        end

        respond_with @survey, location: admin_survey_question_groups_path(@survey)
      end

      def move_down
        if @question_group.reload.position < Helena::QuestionGroup.maximum_position(@version)
          @question_group.swap_position @question_group.position + 1
          notify_successful_update_for(@question_group.title)
        end

        respond_with @survey, location: admin_survey_question_groups_path(@survey)
      end

      private

      def resort
        Helena::QuestionGroup.resort @version
      end

      def load_resources
        @survey = Helena::Survey.find params['survey_id']
        @version = @survey.versions.find_by(version: 0)
      end

      def find_question_group
        @question_group = @version.question_groups.find(params[:id])
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @survey.name, admin_survey_question_groups_path(@survey)
      end

      def question_group_params
        params.require(:question_group).permit(:title)
      end
    end
  end
end
