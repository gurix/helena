module Helena
  class Survey
    include Helena::Concerns::ApplicationModel

    default_scope -> { asc :position }

    after_destroy :resort

    field :name,        type: String
    field :description, type: String
    field :position,    type: Integer, default: 1

    embeds_many :versions, inverse_of: :survey, class_name: 'Helena::Version'
    has_many :sessions, inverse_of: :survey, dependent: :destroy, class_name: 'Helena::Session'

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
      versions.find_by version: 0
    end

    def newest_version
      versions.find_by version: versions.max(:version)
    end

    def self.resort
      all.each_with_index do | survey, index |
        survey.update_attribute(:position, index + 1)
      end
    end

    def self.maximum_position
      max(:position) || 0
    end

    private

    def resort
      self.class.resort
    end
  end
end
