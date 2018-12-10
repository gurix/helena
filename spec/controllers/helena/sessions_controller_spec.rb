require 'spec_helper'

describe Helena::SessionsController do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }
  let(:version) { survey.versions.create version: 0, question_groups: [build(:question_group)] }
  let(:session) do
    create :session, survey: survey, version: version, answers: [
      build(:string_answer, code: 'string_answer_1', value: 'abc'),
      build(:integer_answer, code: 'integer_answer_1', value: '123')
    ]
  end

  context 'version not active' do
    before { version.update_attribute :active, false }

    it 'raises not found when editing' do
      get :edit, parametrize(token: session.token)
      is_expected.to respond_with :not_found
    end

    it 'raises not found when updating' do
      patch :update, parametrize(token: session.token)
      is_expected.to respond_with :not_found
    end
  end

  it 'return json result of the current session' do
    get :show, parametrize(token: session.view_token).merge(format: :json)

    result = ActiveSupport::JSON.decode(response.body)
    expect(result['answer']['string_answer_1']).to eq 'abc'
    expect(result['answer']['integer_answer_1']).to eq 123
  end

  it 'renders session_report as slim template' do
    session.version.update_attribute :session_report, 'h1 make it slim!'
    get :show, parametrize(token: session.view_token)

    expect(response.body).to eq '<h1>make it slim!</h1>'
  end
end
