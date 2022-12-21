class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  def render
    {
      username: user.username
    }
  end
end
