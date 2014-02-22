require_dependency 'helena/application_controller'

module Helena
  class SurveysController < ApplicationController
    respond_to :html, :json

    before_filter :authenticate_administrator!, except: :index

    def index
      @surveys = Helena::Survey.all
    end

    def edit
      @survey = Helena::Survey.find params[:id]
    end

    def update
      @survey = Helena::Survey.find params[:id]
      if @survey.update_attributes survey_params
        flash[:notice] = t('actions.updated', ressource: @survey.name)
      else
        flash[:error] = t 'actions.error'
      end
      respond_with @survey, location: surveys_path
    end

    def destroy
      @survey = Helena::Survey.find(params[:id])
      flash[:notice] = t('actions.deleted', ressource: @survey.name) if @survey.destroy
      respond_with @survey, location: surveys_path
    end

    private

    def survey_params
      params.require(:survey).permit(:name, :description)
    end
  end
end
