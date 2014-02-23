require_dependency 'helena/application_controller'

module Helena
  module Admin
    class SurveysController < Admin::ApplicationController
      respond_to :html, :json

      add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path

      def index
        @surveys = Helena::Survey.all
      end

      def new
        add_breadcrumb t('survey.add')
        @survey = Helena::Survey.new
      end

      def create
        add_breadcrumb t('survey.add')

        @survey = Helena::Survey.new survey_params

        if @survey.save
          flash[:notice] = t('actions.created', ressource: @survey.name)
        else
          flash[:error] = t 'actions.error'
        end
        respond_with @survey, location: admin_surveys_path
      end

      def edit
        @survey = Helena::Survey.find params[:id]
        add_breadcrumb @survey.name
      end

      def update
        @survey = Helena::Survey.find params[:id]
        if @survey.update_attributes survey_params
          flash[:notice] = t('actions.updated', ressource: @survey.name)
        else
          flash[:error] = t 'actions.error'
          add_breadcrumb @survey.name_was
        end
        respond_with @survey, location: admin_surveys_path
      end

      def destroy
        @survey = Helena::Survey.find(params[:id])
        flash[:notice] = t('actions.deleted', ressource: @survey.name) if @survey.destroy
        respond_with @survey, location: admin_surveys_path
      end

      private

      def survey_params
        params.require(:survey).permit(:name, :description)
      end
    end
  end
end
