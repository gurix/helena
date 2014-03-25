module Helena
  module Admin
    module Questions
      class CheckboxGroupsController < Admin::QuestionsController
        private

        def add_ressources
          @question.sub_questions.build
        end

        def permited_params
          [:required, sub_questions_attributes: sub_questions_attributes]
        end
      end
    end
  end
end
