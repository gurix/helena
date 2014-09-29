require 'spec_helper'

describe Helena::Version do
  it { expect(subject).to belong_to(:survey) }

  it { expect(subject).to embed_many(:question_groups) }
  it { expect(subject).to embed_one(:survey_detail) }

  it { expect(subject).to validate_presence_of(:version) }
  it { expect(subject).to validate_uniqueness_of(:version) }

  it 'has a valid factory' do
    expect(build :version, survey: create(:survey)).to be_valid
  end
end
