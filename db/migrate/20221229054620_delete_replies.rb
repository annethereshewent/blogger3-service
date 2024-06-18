class DeleteReplies < ActiveRecord::Migration[7.0]
  def change
    drop_table :replies
    change_table :posts do |t|
      t.references :reply, index: true, foreign_key: { to_table: :posts }
    end
  end
end
