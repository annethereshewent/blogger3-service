C_NOT_CONFIRMED = 100
C_NOT_FOUND = 404
class Api::V1::Users::DashboardController < ApplicationController
  before_action :doorkeeper_authorize!, :current_resource_owner, except: [:fetch_blog_posts, :fetch_comments]

  def fetch_blog_posts

  end

  def fetch_comments

  end

  def dashboard
    unless (@user.confirmed_at.nil?)
      render json: {
        success: true,
        user: @user.render()
      }
    else
      puts "testing 123...."
      puts C_NOT_CONFIRMED
      render json: {
        success: false,
        message: 'user has not confirmed email',
        code: C_NOT_CONFIRMED
      }, status: 400
    end
  end

  def current_resource_owner
    if doorkeeper_token
        @user = User.find(doorkeeper_token.resource_owner_id)
    else
        render json: {
            success: false,
            message: 'user not found',
            code: C_NOT_FOUND
        }, status: 404
    end
  end
end