module Helena
  module Concerns
    module Questions
      module Requirable
        extend ActiveSupport::Concern

        included do
          field :required, type: Boolean, default: false
        end
      end
    end
  end
end
