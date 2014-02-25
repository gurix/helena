class AddSurveyPosition < ActiveRecord::Migration
  def change
    add_column :helena_surveys, :position, :integer, default: 1
  end
end
