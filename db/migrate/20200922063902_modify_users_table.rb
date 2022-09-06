class ModifyUsersTable < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.boolean :avatar_dialog, null: false, default: false
      t.boolean :description_dialog, null: false, default: false
    end
    change_column_null(:users, :username, false)
    change_column_null(:users, :encrypted_password, false)
    change_column_null(:users, :email, false)
  end
end
