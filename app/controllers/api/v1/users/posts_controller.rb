class Api::V1::Users::PostsController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner, except: %i[index]

  def index
    page = params[:page].present? ? params[:page] : 1
    post = Post.includes(:tags).find(params[:id])

    render json: {
      post: post.render
    }
  end

  def replies
    page = params[:page].present? ? params[:page] : 1

    replies = Post
      .replyable_replies(replyable_id: params[:id], page: page)

    render json: {
      replies: replies.map(&:render)
    }
  end

  def parent
    post = Post.find(params[:id])

    render json: {
      post: post.replyable.render
    }
  end
end