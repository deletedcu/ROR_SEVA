class AddSimilarIdToSimilars < ActiveRecord::Migration
  def change
    add_column :similars, :similar_id, :integer
  end
end
