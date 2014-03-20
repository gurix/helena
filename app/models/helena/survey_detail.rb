module Helena
  class SurveyDetail < ActiveRecord::Base
    belongs_to :version, inverse_of: :survey_detail
  end
end
