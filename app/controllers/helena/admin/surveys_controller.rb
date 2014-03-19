require_dependency 'helena/application_controller'

module Helena
  module Admin
    class SurveysController < Admin::ApplicationController
      respond_to :html

      before_filter :add_breadcrumbs
      before_filter :resort, only: [:move_up, :move_down, :create]
      before_filter :load_survey, only: [:edit, :update, :move_up, :move_down, :destroy]

      def index
        @surveys = Helena::Survey.joins(:versions).where(helena_versions: { version: 0 })
      end

      def new
        add_breadcrumb t('.new')
        @survey = Helena::Survey.new
        @survey.versions.build version: 0, survey_detail: Helena::SurveyDetail.new
      end

      def create
        add_breadcrumb t('.new')

        @survey = Helena::Survey.new survey_params
        @survey.position = Helena::Survey.maximum_position + 1

        if @survey.save
          notify_successful_create_for(@survey.name)
        else
          notify_error
        end
        respond_with @survey, location: admin_surveys_path
      end

      def edit
        add_breadcrumb @survey.name
      end

      def update
        if @survey.update_attributes survey_params
          notify_successful_update_for(@survey.name)
        else
          notify_error @survey
          add_breadcrumb @survey.name_was
        end
        respond_with @survey, location: admin_surveys_path
      end

      def move_up
        if @survey.reload.position > 1
          @survey.swap_position @survey.position - 1
          notify_successful_update_for(@survey.name)
        end

        respond_with @survey, location: admin_surveys_path
      end

      def move_down
        if @survey.reload.position < Helena::Survey.maximum_position
          @survey.swap_position @survey.position + 1
          notify_successful_update_for(@survey.name)
        end

        respond_with @survey, location: admin_surveys_path
      end

      def destroy
        notify_successful_delete_for(@survey.name) if @survey.destroy
        respond_with @survey, location: admin_surveys_path
      end

      private

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
      end

      def resort
        Helena::Survey.resort
      end

      def survey_params
        params.require(:survey).permit(:name, versions_attributes: [:version, :id, survey_detail_attributes: [:title, :description]])
      end

      def load_survey
        @survey = Helena::Survey.find params[:id]
      end
    end
  end
end
