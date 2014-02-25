class AddPositionToQuestionGroup < ActiveRecord::Migration
  def change
    add_column :helena_question_groups, :position, :integer, default: 1
  end
end
