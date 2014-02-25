require_dependency 'helena/application_controller'

module Helena
  class SurveysController < ApplicationController
    respond_to :html, :json

    def index
      @surveys = Helena::Survey.all
    end
  end
end
