module Helena
  module Concerns
    module Questions
      module Validatable
        extend ActiveSupport::Concern

        def rules
          self.validation_rules ||= {}
        end
      end
    end
  end
end
