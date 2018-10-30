class AddUserNameToLead < ActiveRecord::Migration
  def change
    add_column :leads, :user_name, :string
  end
end
