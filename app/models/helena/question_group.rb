module Helena
  class QuestionGroup < ActiveRecord::Base
    belongs_to :survey

    default_scope { order(position: :asc) }
  end
end
