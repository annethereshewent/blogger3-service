class Reply < ApplicationRecord
  belongs_to :replyable, polymorphic: true

  has_many :replies, as: :replyable

  def reply
    {
      body: body,
      replies: replies.map(&:render)
      replyable: replyable,
      replyable_type: replyable_type
    }
  end
end