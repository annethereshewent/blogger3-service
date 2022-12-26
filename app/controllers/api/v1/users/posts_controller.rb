class Api::V1::Users::PostsController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner, except: %i[index]

  def index
    post = Post.includes(:replies).includes(:tags).find(params[:id])

    render json: {
      post: post.render,
      replies: post.replies.map(&:render)
    }
  end
end