module Helena
  module Questions
    class OptionGroup < Helena::Question
      include Helena::Concerns::Questions::Validatable
      include Helena::Concerns::Questions::Requirable

      has_many :labels, dependent: :destroy
    end
  end
end
