class AddUserIdToReplies < ActiveRecord::Migration[7.0]
  def change
    add_reference :replies, :user, index: true, null: false
  end
end
