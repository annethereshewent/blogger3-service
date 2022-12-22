class AddDisplayNameColumn < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :display_name, null: true
    end
  end
end
