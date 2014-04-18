module Helena
  module Concerns
    module  ApplicationModel
      extend ActiveSupport::Concern

      include Mongoid::Document
      include Mongoid::Timestamps

      included do
        before_destroy   :removable?

        # Removable is given by default. Override for custom behaviour
        def removable?
          true
        end
      end
    end
  end
end
