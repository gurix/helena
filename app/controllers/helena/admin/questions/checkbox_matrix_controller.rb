module Helena
  module Admin
    module Questions
      class CheckboxMatrixController < Admin::QuestionsController
        include Helena::Concerns::Questions::MatrixQuestions
      end
    end
  end
end
