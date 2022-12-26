class Reply < ApplicationRecord
  belongs_to :replyable, polymorphic: true
  belongs_to :user

  has_many :replies, as: :replyable
  has_many :likes, as: :likeable

  has_many_attached :images do |attachable|
    attachable.variant :preview, resize_to_limit: [400, nil]
  end

  has_one_attached :gif

  def render
    {
      id: id,
      body: body,
      user: user.render,
      created_at: created_at,
      likes: likes.map(&:render),
      like_count: likes.count,
      reply_count: replies.count,
      images: images.map{ |image| {
        original: image.url,
        preview: image.variant(:preview).processed.url
      } }
    }
  end

  def self.replyable_replies(replyable_id:, replyable_type:, page:)
    Reply
      .includes(:likes)
      .where(replyable_id: replyable_id, replyable_type: replyable_type)
      .order(created_at: :asc)
      .paginate(page: page, per_page: 20)
  end
end