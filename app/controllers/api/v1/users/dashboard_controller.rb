C_NOT_CONFIRMED = 100
C_NOT_FOUND = 404
class Api::V1::Users::DashboardController < ApplicationController
  include ERB::Util
  before_action :doorkeeper_authorize!, :current_resource_owner, except: [:fetch_blog_posts, :fetch_comments]

  def fetch_posts
    posts = @user.posts.order(updated_at: :desc)

    render json: {
      posts: posts.map(&:render)
    }
  end

  def create_post
    post = Post.create(
      body:  html_escape(params[:body]),
      user_id: @user.id,
      repost_id: params[:repost_id],
      images: params[:images]
    )

    render json: {
      post: post.render()
    }

  end

  def fetch_comments

  end

  def hide_avatar_dialog
    @user.avatar_dialog = true

    @user.save

    render json: {
      changed: true
    }
  end

  def dashboard
    unless (@user.confirmed_at.nil?)
      render json: {
        user: @user.render()
      }
    else
      render json: {
        message: 'user has not confirmed email',
        code: C_NOT_CONFIRMED,
        # the frontend will need the user regardless
        user: @user.render()
      }, status: 400
    end
  end

  def current_resource_owner
    if doorkeeper_token
      @user = User.find(doorkeeper_token.resource_owner_id)
    else
      render json: {
        message: 'user not found',
        code: C_NOT_FOUND
      }, status: 404
    end
  end

  private
    def post_params
      params.permit(:body, :repost_id, :images)
    end
end