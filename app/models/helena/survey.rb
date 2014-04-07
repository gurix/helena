module Helena
  class Survey < ActiveRecord::Base
    default_scope { order(position: :asc) }

    after_destroy :resort

    has_many :versions, inverse_of: :survey, dependent: :destroy
    has_many :sessions, inverse_of: :survey, dependent: :destroy

    accepts_nested_attributes_for :versions

    validates :name, presence: true, uniqueness: true

    def swap_position(new_position)
      other_survey = self.class.find_by(position: new_position)
      if other_survey
        other_survey.update_attribute :position, position
        update_attribute :position, new_position
      end
    end

    def draft_version
      versions.find_by(version: 0)
    end

    def last_version
      versions.find_by version: versions.maximum(:version)
    end

    def self.resort
      all.each_with_index do | survey, index |
        survey.update_attribute(:position, index + 1)
      end
    end

    def self.maximum_position
      maximum(:position) || 0
    end

    private

    def resort
      self.class.resort
    end
  end
end
