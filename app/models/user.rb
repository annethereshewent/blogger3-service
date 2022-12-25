
class User < ApplicationRecord
  include ImageHelpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one_attached :avatar do |attachable|
    attachable.variant :large, resize_to_limit: [400,400]
    attachable.variant :medium, resize_to_limit: [200, 200]
    attachable.variant :small, resize_to_limit: [80,80]
    attachable.variant :thumb, resize_to_limit: [50,50]
  end
  has_one_attached :banner do |attachable|
    attachable.variant :default, resize_to_limit: [700,200]
  end

  has_many :posts
  has_many :likes
  has_many :follows


 # Will return an array of follows for the given user instance
  has_many :received_follows, foreign_key: :followee_id, class_name: "Follow"

  # Will return an array of users who follow the user instance
  has_many :followers, through: :received_follows, source: :follower

  # returns an array of follows a user gave to someone else
  has_many :given_follows, foreign_key: :follower_id, class_name: "Follow"

  # returns an array of other users who the user has followed
  has_many :followees, through: :given_follows, source: :followee


  has_many :access_grants,
    class_name: 'Doorkeeper::AccessGrant',
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
    class_name: 'Doorkeeper::AccessToken',
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  def render

    {
      email: self.email,
      username: self.username,
      display_name: self.display_name,
      description: self.description,
      post_count: self.posts.count,
      avatars: {
        large: self.avatar.variant(:large)&.processed&.url,
        medium: self.avatar.variant(:medium)&.processed&.url,
        small: self.avatar.variant(:small)&.processed&.url,
        thumb: self.avatar.variant(:thumb)&.processed&.url,
      },
      gender: self.gender,
      confirmed_at: self.confirmed_at,
      avatar_dialog: self.avatar_dialog,
      banner: self.banner.variant(:default)&.processed&.url,
      join_date: self.created_at,
      num_followers: followers.count,
      num_followed: followees.count
    }
  end

  def ordered_posts(page)
    self
      .posts
      .includes(:tags)
      .paginate(page: page, per_page: 20)
      .includes(:tags)
      .order(created_at: :desc)
  end
end
