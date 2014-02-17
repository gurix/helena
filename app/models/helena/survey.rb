module Helena
  class Survey < ActiveRecord::Base
    belongs_to :participant
    has_many :question_groups, dependent: :destroy

    validates :name,    presence: true
  end
end
