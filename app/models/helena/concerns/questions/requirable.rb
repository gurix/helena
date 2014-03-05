module Helena
  module Concerns
    module Questions
      module Requirable
        extend ActiveSupport::Concern

        def required
          rules[:presence].present?
        end

        def required=(value)
          rules[:presence] = (value.to_i == 1)
        end
      end
    end
  end
end
