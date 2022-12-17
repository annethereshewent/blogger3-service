class CreateTagsTables < ActiveRecord::Migration[7.0]
  def change
    create_table :post_tags do |t|
      t.references :post
      t.references :tag
    end
  end
end
