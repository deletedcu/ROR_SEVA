class RemoveSimilarId < ActiveRecord::Migration
  def change
  	remove_column :similars, :similar_to_id
  end
end
