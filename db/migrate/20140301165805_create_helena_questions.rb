class CreateHelenaQuestions < ActiveRecord::Migration
  def change
    create_table :helena_questions do |t|
      t.belongs_to :question_group
      t.string     :type
      t.string     :code, null: false
      t.integer    :position, default: 1
      t.string     :question_text
      t.text       :default_value
      t.text       :validation_rules

      t.timestamps
    end
  end
end
