require 'spec_helper'

describe Helena::Session do
  let(:survey) { create :survey }
  let(:version) { survey.versions.create }
  let(:session) { survey.sessions.create version: version }

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
    session.answers << Helena::Answer.build_generic('a', 42, '192.168.0.1')
    session.answers << Helena::Answer.build_generic('b', true, '192.235.0.1')
    session.answers << Helena::Answer.build_generic('c', 'Barbra Streisand!!', '192.999.0.1')

    csv = Helena::Session.to_csv

    expect(csv).to include 'a,b,c'
    expect(csv).to include '42,true,Barbra Streisand!!'
  end

  describe '#answers_as_yaml and #answer_as_yaml=' do
    before do
      session.answers << Helena::Answer.build_generic('c', 'Barbra Streisand!!', '192.999.0.1')
      session.answers << Helena::Answer.build_generic('a', 42, '192.168.0.1')
      session.answers << Helena::Answer.build_generic('b', true, '192.235.0.1')
    end

    it 'prints answers as yaml' do
      expect(session.answers_as_yaml).to eq "---\na: 42\nb: 'true'\nc: Barbra Streisand!!\n"
    end

    it 'updates a value by a given yaml' do
      expect do
        session.answers_as_yaml = 'a: 666'
        session.save
      end.to change { session.answers.find_by(code: 'a').value }.from(42).to(666)
    end

    it 'does not affect the answer when the value is the same' do
      expect do
        session.answers_as_yaml = 'a: 42'
        session.save
      end.not_to change { session.answers.find_by code: 'a' }
    end

    it 'removes existings answers that is not in the yaml' do
      expect do
        session.answers_as_yaml = 'x: "test"'
        session.save
      end.to change { session.reload.answers.size }.by(-2)

      expect(session.answers.in(code: %w(a b c)).size).to eq 0
    end
  end
end
