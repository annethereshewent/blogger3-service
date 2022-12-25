class Api::V1::Users::RepliesController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner

  def create
    reply = Reply.create(body: params[:body], replyable_id: params[:replyable_id], replyable_type: params[:replyable_type])

    render json: {
      reply: reply.render
    }
  end
end