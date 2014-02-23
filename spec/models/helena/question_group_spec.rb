require 'spec_helper'

describe Helena::QuestionGroup do

  it { expect(subject).to validate_uniqueness_of(:position).scoped_to(:survey_id) }

  it { expect(subject).to belong_to(:survey) }

  it 'has a valid factory' do
    expect(build :question_group).to be_valid
  end

end
