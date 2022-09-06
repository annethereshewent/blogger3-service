class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.timestamps
      t.references :repost, index: true, foreign_key: { to_table: :posts }
      t.references :user, index: true, foreign_key: { to_table: :users }
    end
  end
end
