require 'open-uri'

C_POST_BODY_EMPTY=101
C_NOT_CONFIRMED = 100
C_NOT_FOUND = 404

class Api::V1::Users::DashboardController < ApplicationController
  include ERB::Util
  include ImageHelpers
  before_action :doorkeeper_authorize!, :current_resource_owner, except: [:fetch_blog_posts, :fetch_comments]

  def fetch_posts
    posts = @user.posts.limit(20).order(updated_at: :desc)

    render json: {
      posts: posts.map(&:render)
    }
  end

  def create_post
    unless params[:body].strip.empty? && params[:gif].nil? && params[:images].nil?
      post = Post.new(
        body:  html_escape(params[:body]),
        user_id: @user.id,
        repost_id: params[:repost_id],
        images: params[:images]
      )

      # finally process any gifs that may be in request
      save_gif(post, params[:gif], params[:original_gif_url]) if !params[:gif].nil? && !params[:original_gif_url].nil?

      post.save

      render json: {
        post: post.render()
      }
    else
      render json: {
        message: 'post body is empty',
        code: C_POST_BODY_EMPTY
      }, status: 400
    end

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

  def user
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

  def search_gifs
    json = HTTParty.get("#{ENV["GIF_TENOR_BASE"]}/search", {
        query: {
          key: ENV["GIF_TENOR_API_KEY"],
          q: params[:search_term],
          media_filter: 'mp4,gif'
        }
      }
    )

    render json: json
  end


  private
    def post_params
      params.permit(:body, :repost_id, :images)
    end

    def save_gif(post, gif_url, original_gif_url)
      post.gif.attach(
        io: URI.parse(gif_url).open,
        filename: gif_url.split('/').last
      )

      post.original_gif_url = original_gif_url
    end
end