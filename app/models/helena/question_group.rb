module Helena
  class QuestionGroup < ActiveRecord::Base
    belongs_to :survey

    default_scope { order(group_order: :asc) }
  end
end
