class AddVerifiedToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :verified, :boolean
    add_column :players, :verified_by, :integer
    add_column :players, :submitted_by, :integer
    add_column :players, :last_edited_by, :integer
  end
end
