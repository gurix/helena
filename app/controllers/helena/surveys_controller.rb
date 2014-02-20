require_dependency 'helena/application_controller'

module Helena
  class SurveysController < ApplicationController
    respond_to :html, :json

    before_filter :authenticate_administrator!, only: [:create, :update, :destroy]

    def index
      @surveys = Helena::Survey.all
      respond_with @survey
    end

    def destroy
      @survey = Helena::Survey.find(params[:id])
      flash[:notice] = t('actions.deleted', ressource: @survey.name) if @survey.destroy
      respond_with @survey, location: surveys_path
    end
  end
end
