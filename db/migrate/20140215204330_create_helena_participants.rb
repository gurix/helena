class CreateHelenaParticipants < ActiveRecord::Migration
  def change
    create_table :helena_participants do |t|
      t.string :name

      t.timestamps
    end
  end
end
