require 'spec_helper'

describe Helena::Version do
  it { expect(subject).to belong_to(:survey) }

  it { expect(subject).to have_many(:question_groups).dependent(:destroy) }
  it { expect(subject).to have_many(:questions).dependent(:destroy) }
  it { expect(subject).to have_one(:survey_detail).dependent(:destroy) }

  it { expect(subject).to validate_presence_of(:version) }
  it { expect(subject).to validate_presence_of(:survey) }
  it { expect(subject).to validate_uniqueness_of(:version).scoped_to(:survey_id) }

  it 'has a valid factory' do
    expect(build :version, survey: create(:survey)).to be_valid
  end
end
