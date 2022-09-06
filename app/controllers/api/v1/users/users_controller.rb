class Api::V1::Users::UsersController < ApplicationController
  def confirmation_status
    user = User.find(params[:id])

    return render json: {
      confirmed: user.confirmed_at != nil
    }
  end

end