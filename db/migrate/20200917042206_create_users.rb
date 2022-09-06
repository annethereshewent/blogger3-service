class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password, null: false
      t.text :description
      t.string :gender, limit: 1
      t.text :profile_image_url
      t.boolean :push_enabled
      t.text :banner_image_url
      t.timestamps
    end
  end
end
