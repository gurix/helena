module Helena
  class Version
    include Helena::Concerns::ApplicationModel
    include Mongoid::Orderable # Needed, because the embedded objects needs this, see

    field :version,        type: Integer, default: 0
    field :notes,          type: String
    field :session_report, type: String

    embedded_in :survey

    embeds_many :question_groups, class_name: 'Helena::QuestionGroup'
    embeds_many :sessions, class_name: 'Helena::Session'

    embeds_one :survey_detail, class_name: 'Helena::SurveyDetail'

    accepts_nested_attributes_for :survey_detail
    accepts_nested_attributes_for :question_groups

    scope :without_base, -> { where(:version.gt => 0) }

    validates :version, presence: true
    validates :version, uniqueness: { scope: :survey_id }

    def question_codes
      question_groups.map(&:question_codes).flatten
    end

    def questions
      question_groups.map(&:questions).flatten
    end

    def question_code_occurences
      question_codes.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    end
  end
end
