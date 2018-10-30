class AddSimilarNameToSimilars < ActiveRecord::Migration
  def change
  	remove_column :similars, :similar_id
    add_column :similars, :similar_name, :string
  end
end
