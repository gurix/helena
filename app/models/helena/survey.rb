module Helena
  class Survey < ActiveRecord::Base
    default_scope { order(position: :asc) }

    belongs_to :participant
    has_many :question_groups, dependent: :destroy

    validates :name, presence: true
    validates :name, uniqueness: true

    def swap_position(new_position)
      other_survey = self.class.find_by(position: new_position)
      if other_survey
        other_survey.update_attribute :position, position
        update_attribute :position, new_position
      end
    end
  end
end
