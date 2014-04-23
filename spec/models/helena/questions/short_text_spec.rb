require 'spec_helper'

describe Helena::Questions::ShortText do
  it 'has a valid factory' do
    expect(build :short_text_question).to be_valid
  end
end
