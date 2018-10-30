class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :espn, default: 0
      t.integer :scout, default: 0
      t.integer :rivals, default: 0
      t.belongs_to :player


      t.timestamps null: false
    end
  end
end
