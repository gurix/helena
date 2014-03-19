require 'spec_helper'

describe Helena::SurveysController do
  routes { Helena::Engine.routes }

  it 'lists only root surveys', pending: true do
    base_survey = create :survey
    copied_survey = create :survey, version: build(:version), survey: base_survey

    get :index

    expect(assigns :surveys).to include base_survey
  end
end
