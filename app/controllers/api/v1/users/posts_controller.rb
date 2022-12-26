class Api::V1::Users::PostsController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner, except: %i[index]

  def index
    page = params[:page].present? ? params[:page] : 1
    post = Post.includes(:tags).find(params[:id])

    render json: {
      post: post.render
    }
  end
end