module Helena
  module Admin
    module Questions
      class RadioMatrixController < Admin::QuestionsController
        private

        def add_ressources
          @question.labels.build
          @question.sub_questions.build
        end

        def permited_params
          [:required, labels_attributes: labels_attributes, sub_questions_attributes: sub_questions_attributes]
        end
      end
    end
  end
end
