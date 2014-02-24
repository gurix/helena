class AddPositionToQuestionGroup < ActiveRecord::Migration
  def change
    add_column :helena_question_groups, :group_order, :integer, default: 1
  end
end
