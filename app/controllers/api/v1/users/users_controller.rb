class Api::V1::Users::UsersController < ApplicationController
  include ImageHelpers

  before_action :doorkeeper_authorize!, :current_resource_owner, except: [:confirmation_status]
  def confirmation_status
    user = User.find(params[:id])

    return render json: {
      confirmed: user.confirmed_at != nil
    }
  end

  def update_avatar
    decoded_image = decode_base64_image(params[:avatar])
    content_type = get_content_type(params[:avatar])

    @user.avatar = {
      io: decoded_image,
      content_type: content_type,
      filename: "#{random_string}.#{content_type.split('/')[1]}"
    }

    @user.save

    render json: {
      user: @user.render()
    }
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
end