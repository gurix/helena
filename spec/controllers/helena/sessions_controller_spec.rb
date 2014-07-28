require 'spec_helper'

describe Helena::SessionsController do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }
  let(:session) do
    baseversion = survey.versions.create version: 0
    version = Helena::VersionPublisher.publish(baseversion)
    version.save
    create :session, survey: survey, version: version, answers: [
      build(:string_answer, code: 'string_answer_1', value: 'abc'),
      build(:integer_answer, code: 'integer_answer_1', value: '123')
    ]
  end

  it 'return json result of the current session' do
    get :show, token: session.view_token, format: :json

    result = ActiveSupport::JSON.decode(response.body)
    expect(result['answer']['string_answer_1']).to eq 'abc'
    expect(result['answer']['integer_answer_1']).to eq 123
  end
end
