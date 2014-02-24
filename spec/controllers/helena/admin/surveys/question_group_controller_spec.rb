require 'spec_helper'

describe Helena::Admin::Surveys::QuestionGroupsController  do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }
  let!(:first_question_group) { create :question_group, group_order: 1, survey: survey }
  let!(:second_question_group) { create :question_group, group_order: 12, survey: survey }
  let!(:third_question_group) { create :question_group, group_order: 33, survey: survey }

  it 'moves a question group down with resort' do
    patch :move_down, survey_id: survey, id: first_question_group

    expect(first_question_group.reload.group_order).to eq 2
    expect(second_question_group.reload.group_order).to eq 1
    expect(third_question_group.reload.group_order).to eq 3
  end

  it 'moves a question group up with resort' do
    patch :move_up, survey_id: survey, id: third_question_group

    expect(first_question_group.reload.group_order).to eq 1
    expect(second_question_group.reload.group_order).to eq 3
    expect(third_question_group.reload.group_order).to eq 2
  end

  it 'does not moves a question group down when already the first with resort' do
    patch :move_down, survey_id: survey, id: third_question_group

    expect(first_question_group.reload.group_order).to eq 1
    expect(second_question_group.reload.group_order).to eq 2
    expect(third_question_group.reload.group_order).to eq 3
  end

  it 'does not moves a question group up when already the first with resort' do
    patch :move_up, survey_id: survey, id: first_question_group

    expect(first_question_group.reload.group_order).to eq 1
    expect(second_question_group.reload.group_order).to eq 2
    expect(third_question_group.reload.group_order).to eq 3
  end

  it 'does resort after deleting a question group' do
    delete :destroy, survey_id: survey, id: first_question_group

    expect(second_question_group.reload.group_order).to eq 1
    expect(third_question_group.reload.group_order).to eq 2
  end
end
