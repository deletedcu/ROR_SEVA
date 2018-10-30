class AddDefaultValueToPlayers < ActiveRecord::Migration
  def change
  	change_column :players, :weekly_impressions_count, :integer, default: 0
  	change_column :players, :trending_rank, :integer, default: 0
  end
end
