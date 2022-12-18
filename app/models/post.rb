class Post < ApplicationRecord
  include ImageHelpers

  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags

  has_many_attached :images do |attachable|
    attachable.variant :preview, resize_to_limit: [400, nil]
  end

  has_one_attached :gif

  def render
    {
      id: self.id,
      body: self.body,
      user: self.user.render(),
      images: self.images.map{ |image| image.url },
      tags: self.tags.map{ |tag| tag.tag },
      gif: self.gif.url,
      original_gif_url: self.original_gif_url,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end
end
