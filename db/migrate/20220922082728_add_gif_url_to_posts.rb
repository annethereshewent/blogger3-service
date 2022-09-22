class AddGifUrlToPosts < ActiveRecord::Migration[7.0]
  def change
    change_table :posts do |t|
      t.string :original_gif_url, null: true
    end
  end
end
