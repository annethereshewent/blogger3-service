require 'open-uri'

C_POST_BODY_EMPTY=101
C_NOT_CONFIRMED = 100
C_NOT_FOUND = 404

class Api::V1::Users::DashboardController < ApplicationController
  include ERB::Util
  include ImageHelpers
  before_action :doorkeeper_authorize!, :current_resource_owner, except: %i[fetch_user_posts fetch_comments fetch_posts_by_tag]

  def fetch_posts
    page = params[:page].present? ? params[:page] : 1

    posts = Post.dashboard_posts(page, [@user.id] + @user.followees.map(&:id))

    render json: {
      posts: posts.map(&:render)
    }
  end

  def fetch_posts_by_tag
    page = params[:page].present? ? params[:page] : 1

    posts = Post.posts_by_tag(params[:tag], page)

    render json: {
      posts: posts.map(&:render)
    }
  end

  def update_post_likes
    post = Post.find(params[:id])

    like = Like.find_by(post_id: params[:id], user_id: @user.id)

    if like.present?
      like.destroy
    else
      Like.create(user_id: @user.id, post_id: post.id)

       post.touch
    end

    render json: {
      post: post.render()
    }
  end

  def create_post
    unless params[:body].strip.empty? && params[:gif].nil? && params[:images].nil?
      sanitized_body = ActionController::Base.helpers.sanitize(params[:body], tags: ["img", "br", "div"], attributes: ["src", "class"])

      puts "THE REPLY ID IS EQUAL TO #{params[:reply_id]}"

      post = Post.new(
        body:  sanitized_body,
        user_id: @user.id
      )

      if params[:reply_id].present?
        post.reply_id = params[:reply_id]
      end

      if params[:repost_id].present?
        post.repost_id = params[:repost_id]
      end

      # finally process any gifs that may be in request
      save_gif(post, params[:gif], params[:original_gif_url]) if !params[:gif].nil? && !params[:original_gif_url].nil?

      post.save!

      if params[:tags].present?
        params[:tags].each do |tag|
          tag = Tag.find_by(tag: tag) || Tag.create(tag:tag)

          PostTag.create(tag_id: tag.id, post_id: post.id)
        end
      end

      render json: {
        post: post.render,
        replyable: post.replyable&.render
      }
    else
      render json: {
        message: 'post body is empty',
        code: C_POST_BODY_EMPTY
      }, status: 400
    end

  end

  def fetch_replies

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

  def upload_images
    post = Post.find(params[:id])
    post.images.attach(params[:files])

    render json: {
      post: post.render()
    }
  end

  private
    def post_params
      params.permit(:body, :repost_id, :images)
    end
end