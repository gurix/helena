module Helena
  class QuestionGroup < ActiveRecord::Base
    belongs_to :survey
  end
end
