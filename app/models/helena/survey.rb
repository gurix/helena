module Helena
  class Survey
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable

    orderable

    field :name,        type: String
    field :description, type: String

    embeds_many :versions, inverse_of: :survey, class_name: 'Helena::Version'
    has_many :sessions, inverse_of: :survey, dependent: :destroy, class_name: 'Helena::Session'

    accepts_nested_attributes_for :versions

    validates :name, presence: true, uniqueness: true

    def draft_version
      versions.find_by version: 0
    end

    def newest_version
      versions.find_by version: versions.max(:version)
    end
  end
end
