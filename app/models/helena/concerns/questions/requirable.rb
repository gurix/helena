module Helena
  module Concerns
    module Questions
      module Requirable
        extend ActiveSupport::Concern

        included do
          field :required, type: Boolean, default: false
        end

        def validate_answers_in(answers)
          errors = {}
          errors[code] = :blank if answers[code].blank? && required
          errors
        end
      end
    end
  end
end
