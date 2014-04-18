module Helena
  class Version
    include Helena::Concerns::ApplicationModel

    field :version, type: Integer, default: 0
    field :notes,   type: String

    embedded_in :survey, inverse_of: :versions

    embeds_many :question_groups, inverse_of: :version, class_name: 'Helena::QuestionGroup'
    embeds_many :sessions, inverse_of: :version, class_name: 'Helena::Session'

    embeds_one :survey_detail, inverse_of: :version, class_name: 'Helena::SurveyDetail'

    accepts_nested_attributes_for :survey_detail

    scope :without_base, -> { where(:version.gte => 0) }

    validates :survey, presence: true
    validates :version, presence: true
    validates :version, uniqueness: { scope: :survey_id }
  end
end
