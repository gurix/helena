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
end
