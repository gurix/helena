require 'spec_helper'

describe Helena::SessionsController do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }
  let(:version) { survey.versions.create version: 0 }
  let(:session) do
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

  it 'renders session_report as slim template' do
    session.version.update_attribute :session_report, 'h1 make it slim!'
    get :show, token: session.view_token

    expect(response.body).to eq '<h1>make it slim!</h1>'
  end
end
