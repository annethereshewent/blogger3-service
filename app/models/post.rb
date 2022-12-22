class Post < ApplicationRecord
  include ImageHelpers

  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :likes

  has_many_attached :images do |attachable|
    attachable.variant :preview, resize_to_limit: [400, nil]
  end

  has_one_attached :gif

  def self.posts_by_tag(tag, page)
    Post.order('posts.id desc')
      .paginate(page: page, per_page: 20)
      .includes(:tags)
      .where(
        'posts.id in (
          select post_tags.post_id
          from post_tags, tags
          where post_tags.tag_id = tags.id and tags.tag = ?
        )
      ',
      tag
    )
  end

  def render
    {
      id: self.id,
      body: self.body,
      user: self.user.render(),
      images: self.images.map{ |image| {
        original: image.url,
        preview: image.variant(:preview).processed.url
      } },
      tags: self.tags.map{ |tag| tag.tag },
      like_count: likes.count,
      likes: likes.map(&:render),
      gif: self.gif.url,
      original_gif_url: self.original_gif_url,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end
end
