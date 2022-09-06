class Post < ApplicationRecord
  has_many_attached :images do |attachable| 
    attachable.variant :preview, resize_to_limit: [400, nil]
  end

  def render 
    {
      body: self.body,
      user_id: self.user_id
    }
  end
end
