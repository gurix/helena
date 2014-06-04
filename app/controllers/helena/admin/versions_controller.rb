require_dependency 'helena/application_controller'

module Helena
  module Admin
    class VersionsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_survey, :add_breadcrumbs
      before_filter :build_version, only: [:new, :create]
      before_filter :load_version,  only: [:edit, :update]

      def index
        @versions = @survey.versions.without_base
      end

      def new
      end

      def create
        @version.update_attributes(version_params)

        if @version.save
          notify_successful_create_for(@version.version)
        else
          notify_error @version
        end

        respond_with @version, location: admin_survey_versions_path(@survey)
      end

      def edit
      end

      def update
        if @version.update_attributes version_params
          notify_successful_update_for(@version.version)
        else
          notify_error @version
          add_breadcrumb @version.version
        end
        respond_with @version, location: admin_survey_versions_path(@survey)
      end

      def destroy
        @version = @survey.versions.find_by id: params[:id]
        notify_successful_delete_for(@version.version) if @version.destroy
        respond_with @version, location: admin_survey_versions_path(@survey)
      end

      private

      def load_survey
        @survey = Helena::Survey.find(params[:survey_id])
      end

      def load_version
        @version = @survey.versions.find(params[:id])
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @survey.name, admin_survey_versions_path(@survey)
      end

      def version_params
        params.require(:version).permit(:notes, :session_report)
      end

      def default_session_report
        render_to_string 'default_session_report', layout: false
      end

      def build_version
        base_version = @survey.versions.find_by(version: 0)
        @version = Helena::VersionPublisher.publish(base_version)
        @version.session_report = @survey.reload.versions.last.session_report || default_session_report
      end
    end
  end
end
