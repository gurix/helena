module Helena
  module Questions
    class LongText < Helena::Question
      include Helena::Concerns::Questions::Requirable

       field :default_value, type: String
    end
  end
end
