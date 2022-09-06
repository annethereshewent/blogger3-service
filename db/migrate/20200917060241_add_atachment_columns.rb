class AddAtachmentColumns < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.remove :banner_image_url, :profile_image_url
    end
  end
end
