module Helena
  module Questions
    class RadioGroup < Helena::Question
      include Helena::Concerns::Questions::Requirable
      include Helena::Concerns::Questions::ValidatesOneLabel

      embeds_many :labels, class_name: 'Helena::Label'

      accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels

      def includes_labels?
        true
      end
    end
  end
end
