class AddOriginalGifUrlToReplies < ActiveRecord::Migration[7.0]
  def change
    add_column :replies, :original_gif_url, :string
  end
end
