class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  def render
    {
      username: user.username
    }
  end
end
