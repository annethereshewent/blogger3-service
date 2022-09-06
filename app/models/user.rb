
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one_attached :avatar do |attachable| 
    attachable.variant :large, resize_to_limit: [500,500]
    attachable.variant :medium, resize_to_limit: [150,150]
    attachable.variant :small, resize_to_limit: [80,80]
    attachable.variant :thumb, resize_to_limit: [50,50]
  end
  has_one_attached :banner do |attachable|
    attachable.variant :default, resize_to_limit: [1500,500]
  end

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
      id: self.id,
      email: self.email,
      username: self.username,
      description: self.description,
      avatar_large: get_url(self.avatar.variant(:large)),
      avatar_medium: get_url(self.avatar.variant(:medium)),
      avatar_small: get_url(self.avatar.variant(:small)),
      avatar_thumb: get_url(self.avatar.variant(:thumb)),
      gender: self.gender,
      confirmed_at: self.confirmed_at
    }
  end

  def get_url(image) 
    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end
end
