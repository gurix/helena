require 'spec_helper'

describe Helena::Question do
  it { expect(subject).to belong_to(:question_group) }
  it { expect(subject).to validate_presence_of(:question_group) }
  it { expect(subject).to validate_presence_of(:version) }
  it { expect(subject).to validate_uniqueness_of(:code).scoped_to(:survey_id) }

  it 'has a valid factory' do
    expect(build :question).to be_valid
  end
end
