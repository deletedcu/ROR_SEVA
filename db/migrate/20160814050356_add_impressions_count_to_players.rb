class AddImpressionsCountToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :impressions_count, :integer
  end
end
