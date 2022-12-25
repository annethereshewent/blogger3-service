class Reply < ApplicationRecord
  belongs_to :replyable, polymorphic: true

  has_many :replies, as: :replyable

  def render
    {
      id: id,
      body: body
    }
  end
end