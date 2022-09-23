class Post < ApplicationRecord
  include ImageHelpers

  belongs_to :user

  has_many_attached :images do |attachable|
    attachable.variant :preview, resize_to_limit: [400, nil]
  end

  has_one_attached :gif

  def render
    {
      id: self.id,
      body: self.body,
      user: self.user.render(),
      images: self.images.map{ |image| image.variant(:preview).url },
      gif: self.gif.url,
      original_gif_url: self.original_gif_url,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end
end
