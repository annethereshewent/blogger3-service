C_REPLY_BODY_EMPTY=201

class Api::V1::Users::RepliesController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner

  def create
    unless params[:body].strip.empty?
      sanitized_body = ActionController::Base.helpers.sanitize(params[:body], tags: ["img", "br", "div"], attributes: ["src", "class"])

      reply = Reply.create!(
        body: sanitized_body,
        replyable_id: params[:replyable_id],
        replyable_type: params[:replyable_type],
        user_id: @user.id
      )

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
end