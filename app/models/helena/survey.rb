module Helena
  class Survey < ActiveRecord::Base
    default_scope { order(position: :asc) }

    belongs_to :participant
    has_many :question_groups, dependent: :destroy

    validates :name, presence: true
    validates :name, uniqueness: true
  end
end
