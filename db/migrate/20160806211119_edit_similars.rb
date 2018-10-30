class EditSimilars < ActiveRecord::Migration
  def change
  	remove_column :similars, :name
  	remove_column :similars, :current
  	remove_column :similars, :college
  	add_column :similars, :similar_to_id, :integer
  end
end
