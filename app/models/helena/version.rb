module Helena
  class Version < ActiveRecord::Base
    belongs_to :survey, inverse_of: :versions

    has_many :question_groups, dependent: :destroy, inverse_of: :version
    has_many :questions, dependent: :destroy, inverse_of: :version
    has_one :survey_detail, dependent: :destroy, inverse_of: :version

    accepts_nested_attributes_for :survey_detail

    validates :survey, presence: true
    validates :version, presence: true
    validates :version, uniqueness: { scope: :survey_id }
  end
end
