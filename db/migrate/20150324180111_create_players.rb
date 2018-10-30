class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :st
      t.string :committed_to, default: "Undeclared"
      t.string :high_school
      t.string :height
      t.string :position
      t.string :style
      t.string :grad_year
      t.boolean :current,  null: false, default: true
      t.string :school_class
      
      t.timestamps null: false
    end
  end
end
