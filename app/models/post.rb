class Post < ApplicationRecord
  include ImageHelpers
  has_many_attached :images do |attachable|
    attachable.variant :preview, resize_to_limit: [400, nil]
  end

  def render
    {
      body: self.body,
      avatar: get_image_url(self.user.avatar(:medium))
      images: self.images.map{ |image| get_image_url(image(:preview)) }
    }
  end
end
