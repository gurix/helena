module Helena
  class Version
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable # Needed, because the embedded objects needs this, see
    include Mongoid::Tree

    field :version,        type: Integer, default: 0
    field :notes,          type: String
    field :session_report, type: String
    field :active,         type: Boolean, default: false
    field :settings,       type: Hash, default: {}

    belongs_to :survey

    has_many :question_groups, inverse_of: :version, dependent: :destroy, class_name: 'Helena::QuestionGroup', autosave: true
    has_many :sessions, inverse_of: :version, dependent: :destroy, class_name: 'Helena::Session'

    embeds_one :survey_detail, class_name: 'Helena::SurveyDetail'

    accepts_nested_attributes_for :survey_detail, :question_groups

    scope :active, -> { where active: true }

    validates :version, presence: true
    validates :version, uniqueness: { scope: :survey_id }

    def question_codes
      question_groups.map(&:question_codes).flatten
    end

    def question_texts
      question_groups.map(&:question_texts).flatten
    end

    def question_code_occurences
      question_codes.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    end
  end
end
