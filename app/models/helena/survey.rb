module Helena
  class Survey
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable
    include Mongoid::Document::Taggable

    orderable

    field :name,        type: String
    field :language,    type: String

    has_many :versions, inverse_of: :survey, dependent: :destroy, class_name: 'Helena::Version'
    has_many :sessions, inverse_of: :survey, dependent: :destroy, class_name: 'Helena::Session'

    accepts_nested_attributes_for :versions

    validates :name, presence: true, uniqueness: true
    validates :language, presence: true

    def newest_version
      versions.find_by version: versions.max(:version) if versions.any?
    end
  end
end
