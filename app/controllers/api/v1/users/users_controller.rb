class Api::V1::Users::UsersController < ApplicationController
  include ImageHelpers

  before_action :doorkeeper_authorize!, :current_resource_owner, except: [:confirmation_status, :user_exists, :get_user, :get_user_posts, :email_exists]
  def confirmation_status
    user = User.find(params[:id])

    return render json: {
      confirmed: user.confirmed_at != nil
    }
  end

  def user_exists
    user = User.where(username: params[:username]).first

    render json: {
      exists: !user.nil?
    }
  end

  def email_exists
    user = User.find_by_email(params[:email])

    render json: {
      exists: !user.nil?
    }
  end

  def update_avatar
    decoded_image = decode_base64_image(params[:avatar])
    content_type = get_content_type(params[:avatar])

    @user.avatar = {
      io: decoded_image,
      content_type: content_type,
      filename: "#{random_string}.#{content_type.split('/')[1]}"
    }

    @user.save

    render json: {
      user: @user.render
    }
  end

  def get_user_posts
    page = params[:page].present? ? params[:page] : 1

    user = User.find_by(username: params[:username])

    render json: {
      posts: user.ordered_posts(page).map(&:render)
    }
  end

  def get_user
    user = User.find_by(username: params[:username])

    render json: {
      user: user.render
    }
  end

  def save_details
    @user.gender = params[:gender]
    @user.description = params[:description]
    @user.display_name = params[:display_name]

    @user.save

    render json: {
      user: @user.render
    }
  end

  def save_banner
    decoded_image = decode_base64_image(params[:banner_url])
    content_type = get_content_type(params[:banner_url])

    @user.banner = {
      io: decoded_image,
      content_type: content_type,
      filename: "#{random_string}.#{content_type.split('/')[1]}"
    }

    @user.save

    render json: {
      user: @user.render
    }
  end
end