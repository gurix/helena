module Helena
  class Question < ActiveRecord::Base
    belongs_to :question_group, inverse_of: :questions

    default_scope { order(position: :asc) }

    validates :question_group, presence: true

    serialize :validation_rules

    def rules
      validation_rules || {}
    end
  end
end
