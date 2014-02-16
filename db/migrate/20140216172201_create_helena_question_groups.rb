class CreateHelenaQuestionGroups < ActiveRecord::Migration
  def change
    create_table :helena_question_groups do |t|
      t.belongs_to :survey

      t.string :title

      t.timestamps
    end
  end
end
