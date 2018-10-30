class CreateSimilars < ActiveRecord::Migration
  def change
    create_table :similars do |t|
      t.string :name
      t.string :college
      t.boolean :current
      t.belongs_to :player
      
      t.timestamps null: false
    end
  end
end
