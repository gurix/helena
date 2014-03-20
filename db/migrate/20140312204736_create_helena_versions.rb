class CreateHelenaVersions < ActiveRecord::Migration
  def change
    create_table :helena_versions do |t|
      t.belongs_to :survey
      t.integer    :version, default: 0, null: false
      t.text       :notes

      t.timestamps
    end

    remove_belongs_to :helena_question_groups, :survey
    remove_belongs_to :helena_questions, :survey

    add_belongs_to :helena_question_groups, :version
    add_belongs_to :helena_questions, :version

    remove_column :helena_surveys, :description

    create_table :helena_survey_details do |t|
      t.belongs_to :version
      t.string     :title
      t.text       :description

      t.timestamps
    end
  end
end
