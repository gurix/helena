module Helena
  class Version < ActiveRecord::Base
    belongs_to :survey, inverse_of: :versions

    validates :version, presence: true
    validates :version, uniqueness: { scope: :survey_id }
  end
end
