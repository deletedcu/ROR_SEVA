class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.float :seva_win, default: 0
      t.float :seva_ppg, default: 0
      t.float :seva_apg, default: 0
      t.float :seva_rpg, default: 0
      t.float :seva_spg, default: 0
      t.float :seva_bpg, default: 0
      t.float :seva_fg, default: 0
      t.belongs_to :player

      t.timestamps null: false
    end
  end
end
