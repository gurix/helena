module Helena
  module Concerns
    module  ApplicationModel
      extend ActiveSupport::Concern

      include Mongoid::Document
      include Mongoid::Timestamps
      # We need dynamic attributes here to be able to extend our models in combination with the administration gem
      include Mongoid::Attributes::Dynamic
    end
  end
end
