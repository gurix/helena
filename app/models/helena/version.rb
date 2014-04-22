module Helena
  class Version
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable # Needed, because the embedded objects needs this, see

    field :version, type: Integer, default: 0
    field :notes,   type: String

    embedded_in :survey

    embeds_many :question_groups, class_name: 'Helena::QuestionGroup'
    embeds_many :sessions, class_name: 'Helena::Session'

    embeds_one :survey_detail, class_name: 'Helena::SurveyDetail'

    accepts_nested_attributes_for :survey_detail
    accepts_nested_attributes_for :question_groups

    scope :without_base, -> { where(:version.gt => 0) }

    validates :version, presence: true
    validates :version, uniqueness: { scope: :survey_id }
  end
end
