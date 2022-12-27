C_REPLY_BODY_EMPTY=201

class Api::V1::Users::RepliesController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner, except: %i[index]


  def index
    page = params[:page].present? ? params[:page] : 1

    replies = Reply
      .replyable_replies(replyable_id: params[:id], replyable_type: params[:replyable_type], page: page)

    render json: {
      replies: replies.map(&:render)
    }
  end

  def create
    unless params[:body].strip.empty? && params[:gif].nil? && !params[:images]
      sanitized_body = ActionController::Base.helpers.sanitize(params[:body], tags: ["img", "br", "div"], attributes: ["src", "class"])

      reply = Reply.new(
        body: sanitized_body,
        replyable_id: params[:replyable_id],
        replyable_type: params[:replyable_type],
        user_id: @user.id
      )

      # finally process any gifs that may be in request
      save_gif(reply, params[:gif], params[:original_gif_url]) if !params[:gif].nil? && !params[:original_gif_url].nil?

      reply.save!

      reply.replyable.touch


      render json: {
        reply: reply.render
      }
    else
      render json: {
        message: 'Reply body is empty',
        code: C_REPLY_BODY_EMPTY
      }, status: 400
    end
  end

  def upload_images
    reply = Reply.find(params[:id])
    reply.images.attach(params[:files])

    render json: {
      reply: reply.render()
    }
  end

  def update_reply_likes
    reply = Reply.find(params[:id])

    like = Like.find_by(likeable_id: params[:id], likeable_type: 'Reply', user_id: @user.id)

    if like.present?
      like.destroy
    else
      Like.create(user_id: @user.id, likeable_id: reply.id, likeable_type: 'Reply')

      # update both the reply and the reply's parent's updated at
       reply.touch
       reply.replyable.touch
    end

    render json: {
      reply: reply.render()
    }
  end
end