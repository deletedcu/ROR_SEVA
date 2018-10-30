class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :player_name
      t.string :coach_name
      t.string :coach_email
      t.string :user_email

      t.timestamps null: false
    end
  end
end
