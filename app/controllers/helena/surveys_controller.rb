require_dependency 'helena/application_controller'

module Helena
  class SurveysController < ApplicationController
    respond_to :html, :json

    before_filter :authenticate_administrator!, except: :index

    def index
      @surveys = Helena::Survey.all
    end
  end
end
