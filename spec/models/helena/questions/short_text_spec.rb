require 'spec_helper'

describe Helena::Questions::ShortText do
  let(:version) { build :version, version: 0 }
  let(:question_group) { build(:question_group, version: version) }

  it 'has a valid factory' do
    expect(build :short_text_question, question_group: question_group).to be_valid
  end
end
