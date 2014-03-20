module Helena
  class QuestionGroup < ActiveRecord::Base
    belongs_to :version, inverse_of: :question_groups
    has_many :questions

    after_destroy :resort

    default_scope { order(position: :asc) }

    def swap_position(new_position)
      other_version = self.class.find_by(position: new_position, version: version)
      if other_version
        other_version.update_attribute :position, position
        update_attribute :position, new_position
      end
    end

    def self.resort(version)
      where(version: version).each_with_index do | question_group, index |
        question_group.update_attribute(:position, index + 1)
      end
    end

    def self.maximum_position(version)
      where(version: version).maximum(:position) || 0
    end

    private

    def resort
      self.class.resort version
    end
  end
end
