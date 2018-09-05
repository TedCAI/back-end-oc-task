class CreateTableTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      
      t.timestamp
    end
    
    drop_table :table_teams
  end
end
