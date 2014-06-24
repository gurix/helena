require 'spec_helper'

describe Helena::Admin::SessionsController do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }

  context 'without authorization' do
    before { allow_any_instance_of(ApplicationController).to receive(:can_administer?).and_return false }

    specify 'trying to list surveys throws an error' do
      expect { get :index, survey_id: survey }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to export surveys as json throws an error' do
      expect { get :index, survey_id: survey, format: :json }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to export surveys as csv throws an error' do
      expect { get :index, survey_id: survey, format: :csv }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end
  end

  context 'with authorization' do
    before do
      create :session, survey: survey, answers: [
        build(:string_answer, code: 'string_answer_1', value: 'abc'),
        build(:integer_answer, code: 'integer_answer_1', value: '123')
      ]
      create :session, survey: survey, answers: [
        build(:string_answer, code: 'string_answer_2', value: 'def, xyz'),
        build(:integer_answer, code: 'integer_answer_2', value: '456')
      ]
    end

    it 'return json result of all sessions' do
      get :index, survey_id: survey, format: :json

      first_result = ActiveSupport::JSON.decode(response.body).first

      expect(first_result['answers'].first['code']).to eq 'string_answer_2'
      expect(first_result['answers'].first['value']).to eq 'def, xyz'
      expect(first_result['answers'].last['code']).to eq 'integer_answer_2'
      expect(first_result['answers'].last['value']).to eq 456

      last_result = ActiveSupport::JSON.decode(response.body).last

      expect(last_result['answers'].first['code']).to eq 'string_answer_1'
      expect(last_result['answers'].first['value']).to eq 'abc'
      expect(last_result['answers'].last['code']).to eq 'integer_answer_1'
      expect(last_result['answers'].last['value']).to eq 123
    end

    it 'return csv result of all sessions' do
      get :index, survey_id: survey, format: :csv

      csv = CSV.parse(response.body)
      %w(string_answer_2  integer_answer_2 string_answer_1 integer_answer_1).each do |code|
        expect(csv.first).to include code
      end

      ['456', 'def, xyz'].each do |value|
        expect(csv[1]).to include value
      end

      %w(123 abc).each do |value|
        expect(csv[2]).to include value
      end
    end

    specify 'csv header for all sessions does not allow same column names for answers and session fields' do
      create :session, survey: survey, answers: [
        build(:boolean_answer, code: 'completed', value: true),
        build(:string_answer, code: 'token', value: 'abcdefghijklmnopqrstuvwxyz')
      ]
      get :index, survey_id: survey, format: :csv

      csv = CSV.parse(response.body)
      %w(answer_token  answer_completed).each do |code|
        expect(csv.first).to include code
      end
    end
  end
end
