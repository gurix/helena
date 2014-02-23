module Helena
  class QuestionGroup < ActiveRecord::Base
    belongs_to :survey

    validates :position, uniqueness: { scope: :survey_id }
  end
end
