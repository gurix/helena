class CreateHelenaSurveys < ActiveRecord::Migration
  def change
    create_table :helena_surveys do |t|
      t.belongs_to :participant

      t.string :name, null: false, default: ''

      t.timestamps
    end
  end
end
