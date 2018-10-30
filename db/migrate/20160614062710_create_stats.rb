class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.float :seva_score, default: 0.0
      t.float :ppg, default: 0
      t.float :apg, default: 0
      t.float :rpg, default: 0
      t.float :bpg, default: 0
      t.float :spg, default: 0
      t.integer :fg, default: 0
      t.integer :games_played, default: 0
      t.integer :winp, default: 0
      t.integer :season
      t.string :hs_level, default: "NA"
      t.string :year, default: "NA"
      t.belongs_to :player

      t.timestamps null: false
    end
  end
end
