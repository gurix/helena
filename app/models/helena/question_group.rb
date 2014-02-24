module Helena
  class QuestionGroup < ActiveRecord::Base
    include RankedModel

    belongs_to :survey

    ranks :group_order, with_same: :survey_id

    default_scope { order(group_order: :asc) }
  end
end
