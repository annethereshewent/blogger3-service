class AddUsernameColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :username
      t.remove :push_enabled
    end
  end
end
