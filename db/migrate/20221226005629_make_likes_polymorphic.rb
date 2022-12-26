class MakeLikesPolymorphic < ActiveRecord::Migration[7.0]
  def change
    rename_column :likes, :post_id, :likeable_id
    add_column :likes, :likeable_type, :string, null: false, default: 'Post'

    add_index :likes, [:likeable_id, :likeable_type]
  end
end
