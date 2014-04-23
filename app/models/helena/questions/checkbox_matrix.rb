module Helena
  module Questions
    class CheckboxMatrix < Helena::Question
      include Helena::Concerns::Questions::Requirable

      embeds_many :labels, class_name: 'Helena::Label'
      embeds_many :sub_questions, class_name: 'Helena::SubQuestion'

      accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: :reject_labels
      accepts_nested_attributes_for :sub_questions, allow_destroy: true, reject_if: :reject_sub_questions

      def includes_labels?
        true
      end

      def includes_subquestions?
        true
      end
    end
  end
end
