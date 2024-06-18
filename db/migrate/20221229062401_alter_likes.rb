class AlterLikes < ActiveRecord::Migration[7.0]
  def change
    remove_column :likes, :likeable_type
    rename_column :likes, :likeable_id, :post_id

    add_foreign_key :likes, :posts
  end
end
