require 'spec_helper'

describe Helena::SubQuestion do
  it { expect(create :sub_question).to belong_to(:question) }
  it { expect(create :sub_question).to validate_presence_of(:question) }
  it { expect(create :sub_question).to validate_presence_of(:version) }
  it { expect(create :sub_question).to validate_uniqueness_of(:code).scoped_to(:question_id) }
  it { expect(create :sub_question).to validate_uniqueness_of(:text).scoped_to(:question_id) }

  it 'has a valid factory' do
    expect(build :sub_question).to be_valid
  end
end
