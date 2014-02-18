require_dependency 'helena/application_controller'

module Helena
  class SurveysController < ApplicationController
    def index
      @surveys = Helena::Survey.all
    end
  end
end
