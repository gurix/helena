require 'spec_helper'

describe Helena::Admin::VersionsController do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }
  let(:baseversion) { survey.versions.create version: 0 }

  context 'with authorization' do
    it 'deleting a version deletes also the associated sessions' do
      published_version = Helena::VersionPublisher.publish baseversion
      published_version.save

      create :session, survey: survey, version: published_version

      expect { delete :destroy, survey_id: survey, id: published_version }.to change { Helena::Session.count }.by(-1)
    end
  end
end
