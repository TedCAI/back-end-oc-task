class CreateTableTeam < ActiveRecord::Migration[5.1]
  def change
    create_table :table_teams do |t|
      t.string :name
      
      t.timestamp
    end
  end
end
