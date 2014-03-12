require 'spec_helper'

describe Helena::Version do
  it { expect(subject).to belong_to(:survey) }
  it { expect(subject).to validate_presence_of(:version) }
  it { expect(subject).to validate_uniqueness_of(:version).scoped_to(:survey_id) }

  it 'has a valid factory' do
    expect(build :version).to be_valid
  end
end
