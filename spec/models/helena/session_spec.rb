require 'spec_helper'

describe Helena::Session do
  it { expect(subject).to belong_to(:survey) }
  it { expect(subject).to belong_to(:version) }

  it { expect(subject).to embed_many(:answers) }

  it { expect(subject).to validate_uniqueness_of(:token) }
  it { expect(subject).to validate_uniqueness_of(:view_token) }

  it 'has a valid factory' do
    expect(build :session).to be_valid
  end

  it 'assigns a token after when creating a session' do
    expect_any_instance_of(Helena::Session).to receive(:generate_token).exactly(2).times.and_return('a493oP')
    expect(create(:session_without_token).token).to eq 'a493oP'
  end

  it 'exports as CSV with answers' do
    survey = create :survey
    version = survey.versions.create

    session = survey.sessions.create version: version
    session.answers << Helena::Answer.build_generic('a', 42, '192.168.0.1')
    session.answers << Helena::Answer.build_generic('b', true, '192.235.0.1')
    session.answers << Helena::Answer.build_generic('c', 'Barbra Streisand!!', '192.999.0.1')

    csv = Helena::Session.to_csv

    expect(csv).to include 'a,b,c'
    expect(csv).to include '42,true,Barbra Streisand!!'
  end
end
