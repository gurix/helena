module Helena
  module Questions
    class RadioMatrix < Helena::Question
      include Helena::Concerns::Questions::Validatable
      include Helena::Concerns::Questions::Requirable

      validate :labels_preselection

      private

      def labels_preselection
        selected_labels = labels.select { |label| label.preselected == true }
        if selected_labels.size > 1
          selected_labels.each { |label| label.errors.add(:preselected, I18n.t(:taken, scope: 'activerecord.errors.messages')) }
          errors.add(:labels, I18n.t('helena.admin.radio_matrix.only_one_preselection_allowed'))
        end
      end
    end
  end
end
