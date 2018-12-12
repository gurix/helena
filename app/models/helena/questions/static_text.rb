module Helena
  module Questions
    class StaticText < Helena::Question
      field :default_value, type: String

      def required?
        false
      end
    end
  end
end
