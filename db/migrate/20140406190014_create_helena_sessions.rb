class CreateHelenaSessions < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    create_table :helena_sessions do |t|
      t.belongs_to :version
      t.string :token
      t.inet :ip
      t.integer :last_question_group_id
      t.boolean :completed, default: false
      t.hstore :answers
      t.timestamps
    end
  end
end
