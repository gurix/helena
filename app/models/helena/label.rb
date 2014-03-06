module Helena
  class Label < ActiveRecord::Base
    belongs_to :question, inverse_of: :labels

    validates :text, presence: true
    validates :value, presence: true
  end
end
