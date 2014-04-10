require_dependency 'helena/application_controller'

module Helena
  module Admin
    class VersionsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_survey, :add_breadcrumbs

      def index
        @versions = @survey.versions.without_base
      end

      def create
        base_version = @survey.versions.find_by(version: 0)

        @version = Helena::VersionPublisher.publish(base_version)
        @version.notes = version_params['notes']

        if @version.save
          notify_successful_create_for(@version.version)
        else
          notify_error @version
        end

        respond_with @version, location: admin_survey_versions_path(@survey)
      end

      private

      def load_survey
        @survey = Helena::Survey.find(params[:survey_id])
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @survey.name, admin_survey_question_groups_path(@survey)
      end

      def version_params
        params.require(:version).permit(:notes)
      end
    end
  end
end
