
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
    attachable.variant :default, resize_to_limit: [1500,500]
  end

  has_many :posts

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
      description: self.description,
      avatars: {
        large: self.avatar.variant(:large).url,
        medium: self.avatar.variant(:medium).url,
        small: self.avatar.variant(:small).url,
        thumb: self.avatar.variant(:thumb).url,
      },
      gender: self.gender,
      confirmed_at: self.confirmed_at,
      avatar_dialog: self.avatar_dialog
    }
  end
end
