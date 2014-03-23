module Helena
  module Admin
    module Questions
      class RadioMatrixController < Admin::QuestionsController
        private

        def question_params
          params.require(:questions_radio_matrix).permit(:question_text,
                                                         :code,
                                                         :type,
                                                         :required,
                                                         labels_attributes:        labels_attributes,
                                                         sub_questions_attributes: sub_questions_attributes).merge(version_id: @version.id)
        end

        def add_ressources
          @question.labels.build
          @question.sub_questions.build
        end
      end
    end
  end
end
