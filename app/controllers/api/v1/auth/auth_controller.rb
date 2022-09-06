
class Api::V1::Auth::AuthController < ApplicationController
  def register
    user = User.new(user_params)

    if (user.save)
      render json: {
        success: true,
        user: user.render()
      }
    else
      render json: {
        success: false,
        message: 'an error occurred while registering.'
      }
    end
  end

  private
    def user_params
        params.permit(:email, :username, :password, :gender, :description, :banner, :avatar)
    end
end