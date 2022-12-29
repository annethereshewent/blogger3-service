class Post < ApplicationRecord
  include ImageHelpers

  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :likes

  has_many :replies, class_name: 'Post', foreign_key: 'reply_id'
  belongs_to :replyable, class_name: 'Post', foreign_key: 'reply_id', optional: true

  has_many :reposts, class_name: 'Post', foreign_key: 'repost_id'
  belongs_to :repostable, class_name: 'Post', foreign_key: 'repost_id', optional: true

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

  def self.replyable_replies(replyable_id:, page:)
    Post
      .includes(:likes)
      .where(reply_id: replyable_id)
      .order(created_at: :asc)
      .paginate(page: page, per_page: 20)
  end

  def ordered_replies(page)
    self
      .includes(:likes)
      .order(created_at: :asc)
      .where(reply_id: id)
      .paginate(page: page, per_page: 20)
  end

  def render
    {
      id: id,
      body: body,
      user: user.render(),
      images: images.map{ |image| {
        original: image.url,
        preview: image.variant(:preview).processed.url
      } },
      tags: tags.map{ |tag| tag.tag },
      like_count: likes.count,
      likes: likes.map(&:render),
      reply_count: replies.count,
      gif: gif.url,
      original_gif_url: original_gif_url,
      created_at: created_at,
      updated_at: updated_at,
      is_reply: reply_id != nil
    }
  end

   def self.dashboard_posts(page, user_ids)
    Post
      .paginate(page: page, per_page: 20)
      .includes(:tags)
      .where(user_id: user_ids)
      .order(updated_at: :desc)
  end
end
