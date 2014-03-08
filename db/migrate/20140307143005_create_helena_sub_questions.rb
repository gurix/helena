class CreateHelenaSubQuestions < ActiveRecord::Migration
  def change
    create_table :helena_sub_questions do |t|
      t.belongs_to :question
      t.string     :code, null: false
      t.integer    :position, default: 1
      t.string     :question_text
      t.text       :default_value
      t.boolean    :preselected

      t.timestamps
    end
  end
end
