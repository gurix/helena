module Helena
  module Admin
    module Questions
      class StaticTextsController < Admin::QuestionsController
        private

        def permited_params
          [:default_value, :required]
        end
      end
    end
  end
end
