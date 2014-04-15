class CreateHelenaSessions < ActiveRecord::Migration
  def change
    create_table :helena_sessions do |t|
      t.belongs_to :version
      t.belongs_to :survey
      t.string :token
      t.integer :last_question_group_id
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
