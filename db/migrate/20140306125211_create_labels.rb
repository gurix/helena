class CreateLabels < ActiveRecord::Migration
  def change
    create_table :helena_labels do |t|
      t.belongs_to :question

      t.string  :text, null: false
      t.string  :value, null: false
      t.integer :position, default: 1

      t.timestamps
    end
  end
end
