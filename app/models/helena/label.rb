module Helena
  class Label < ActiveRecord::Base
    belongs_to :question, inverse_of: :labels

    default_scope { order(position: :asc) }

    validates :text, presence: true
    validates :value, presence: true
    validates :value, uniqueness: { scope: :question_id }
  end
end
