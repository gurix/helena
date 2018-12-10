module Helena
  module Concerns
    module Questions
      module ValidatesOneLabel
        extend ActiveSupport::Concern

        included do
          validate :labels_preselection
        end

        private

        def labels_preselection
          selected_labels = labels.select { |label| label.preselected == true }
          return if selected_labels.size <= 1

          selected_labels.each { |label| label.errors.add(:preselected, I18n.t(:taken, scope: 'activerecord.errors.messages')) }
          errors.add(:labels, I18n.t('helena.admin.radio_group.only_one_preselection_allowed')) # TODO: How to manage this translation?
        end
      end
    end
  end
end
