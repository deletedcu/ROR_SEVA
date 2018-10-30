class AddWeeklyImpressionsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :weekly_impressions_count, :integer
    add_column :players, :trending_rank, :integer
  end
end
