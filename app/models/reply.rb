class Reply < ApplicationRecord
  belongs_to :replyable, polymorphic: true
  belongs_to :user

  has_many :replies, as: :replyable
  has_many :likes, as: :likeable

  def render
    {
      id: id,
      body: body,
      user: user.render,
      created_at: created_at,
      likes: likes.map(&:render),
      like_count: likes.count,
      reply_count: replies.count
    }
  end
end