require 'spec_helper'

describe Helena::Admin::SurveysController do
  routes { Helena::Engine.routes }

  context 'without authorization' do
    before { ApplicationController.any_instance.stub(:can_administer?).and_return false }

    specify 'trying to list surveys throws an error' do
      expect { get :index }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to edit a survey throws an error' do
      survey = create :survey
      expect { get :edit, id: survey }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to update a survey throws an error' do
      survey = create :survey
      expect { patch :update, id: survey }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to delete a survey throws an error' do
      survey = create :survey
      expect { delete :destroy, id: survey }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to add a survey throws an error' do
      expect { get :new }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end

    specify 'trying to create a survey throws an error' do
      expect { post :create, some: :data }.to raise_error(ActionController::RoutingError, 'Access Denied')
    end
  end

  context 'with authorization' do
    let!(:first_survey) { create :survey,  position: 1, versions: [build(:base_version)] }
    let!(:second_survey) { create :survey,  position: 2, versions: [build(:base_version)] }
    let!(:third_survey) { create :survey,  position: 3, versions: [build(:base_version)] }

    it 'moves a question group down with resort' do
      patch :move_down, id: first_survey
      expect(first_survey.reload.position).to eq 2
      expect(second_survey.reload.position).to eq 1
      expect(third_survey.reload.position).to eq 3
    end

    it 'moves a question group up with resort' do
      patch :move_up, id: third_survey

      expect(first_survey.reload.position).to eq 1
      expect(second_survey.reload.position).to eq 3
      expect(third_survey.reload.position).to eq 2
    end

    it 'does not moves a question group down when already the first with resort' do
      patch :move_down, id: third_survey

      expect(first_survey.reload.position).to eq 1
      expect(second_survey.reload.position).to eq 2
      expect(third_survey.reload.position).to eq 3
    end

    it 'does not moves a question group up when already the first with resort' do
      patch :move_up, id: first_survey

      expect(first_survey.reload.position).to eq 1
      expect(second_survey.reload.position).to eq 2
      expect(third_survey.reload.position).to eq 3
    end

    it 'resorts after deleting a question group' do
      delete :destroy, id: first_survey

      expect(second_survey.reload.position).to eq 1
      expect(third_survey.reload.position).to eq 2
    end

    it 'counts position up when creating a new survey' do
      post :create, survey: { name: 'New Survey' , language: 'en' }

      expect(first_survey.reload.position).to eq 1
      expect(second_survey.reload.position).to eq 2
      expect(third_survey.reload.position).to eq 3
      expect(Helena::Survey.find_by(name: 'New Survey').position).to eq 4
    end
  end
end
