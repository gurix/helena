module Helena
  module Concerns
    module Questions
      module Validatable
        extend ActiveSupport::Concern

        included do
          serialize :validation_rules
        end

        def rules
          self.validation_rules ||= {}
        end
      end
    end
  end
end
