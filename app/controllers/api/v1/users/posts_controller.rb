class Api::V1::Users::PostsController < ApplicationController
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
    post = Post.includes(:tags).where("id in (select reply_id from posts where id = ?)", params[:id]).first

    render json: {
      post: post.render
    }
  end
end