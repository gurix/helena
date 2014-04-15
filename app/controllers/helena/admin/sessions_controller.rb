module Helena
  module Admin
    class SessionsController < Admin::ApplicationController
      respond_to :html

      before_filter :load_survey, :add_breadcrumbs

      def index
        @sessions = @survey.sessions
      end

      def destroy
        @session = @survey.sessions.find_by id: params[:id]
        notify_successful_delete_for(@session.token) if @session.destroy
        respond_with @session, location: admin_survey_sessions_path(@survey)
      end

      private

      def load_survey
        @survey = Helena::Survey.find params['survey_id']
      end

      def add_breadcrumbs
        add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
        add_breadcrumb @survey.name, admin_survey_sessions_path(@survey)
      end
    end
  end
end
