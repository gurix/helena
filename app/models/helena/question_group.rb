module Helena
  class QuestionGroup
    include Helena::Concerns::ApplicationModel

    field :title, type: String
    field :position, type: Integer, default: 1

    embedded_in :version, inverse_of: :question_groups

    embeds_many :questions, class_name: 'Helena::Question'

    after_destroy :resort

    default_scope -> { asc :position }

    def swap_position(new_position)
      other_version = self.class.find_by(position: new_position, version: version)
      if other_version
        other_version.update_attribute :position, position
        update_attribute :position, new_position
      end
    end

    def self.resort(version)
      version.question_groups.each_with_index do | question_group, index |
        question_group.update_attribute(:position, index + 1)
      end
    end

    def self.maximum_position
      max(:position) || 0
    end

    private

    def resort
      self.class.resort version
    end
  end
end
