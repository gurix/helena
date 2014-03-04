require 'spec_helper'

describe Helena::Admin::QuestionsController  do
  routes { Helena::Engine.routes }

  let(:survey) { create :survey }
  let(:question_group) { create :question_group, survey: survey }
  let!(:first_question) { create :question, position: 1, question_group: question_group }
  let!(:second_question) { create :question, position: 12, question_group: question_group }
  let!(:third_question) { create :question, position: 33, question_group: question_group }

  it 'moves a question down with resort' do
    patch :move_down, survey_id: question_group.survey, question_group_id: question_group, id: first_question

    expect(first_question.reload.position).to eq 2
    expect(second_question.reload.position).to eq 1
    expect(third_question.reload.position).to eq 3
  end

  it 'moves a question up with resort' do
    patch :move_up, survey_id: question_group.survey, question_group_id: question_group, id: third_question

    expect(first_question.reload.position).to eq 1
    expect(second_question.reload.position).to eq 3
    expect(third_question.reload.position).to eq 2
  end

  it 'does not moves a question down when already the first with resort' do
    patch :move_down, survey_id: question_group.survey, question_group_id: question_group, id: third_question

    expect(first_question.reload.position).to eq 1
    expect(second_question.reload.position).to eq 2
    expect(third_question.reload.position).to eq 3
  end

  it 'does not moves a question up when already the first with resort' do
    patch :move_up, survey_id: question_group.survey, question_group_id: question_group, id: first_question

    expect(first_question.reload.position).to eq 1
    expect(second_question.reload.position).to eq 2
    expect(third_question.reload.position).to eq 3
  end

  it 'resort after deleting a question' do
    delete :destroy, survey_id: question_group.survey, question_group_id: question_group, id: first_question

    expect(second_question.reload.position).to eq 1
    expect(third_question.reload.position).to eq 2
  end

  it 'counts position up when creating a new survey' do
    post :create, survey_id: question_group.survey, question_group_id: question_group, question: { question_text: 'something?', code: 'A38' }

    expect(first_question.reload.position).to eq 1
    expect(second_question.reload.position).to eq 2
    expect(third_question.reload.position).to eq 3
    expect(question_group.questions.last.position).to eq 4
  end
end
