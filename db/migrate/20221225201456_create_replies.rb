class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.string :body
      t.references :replyable, polymorphic: true
      t.timestamps
    end
  end
end
