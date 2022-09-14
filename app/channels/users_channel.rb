class UsersChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    user = User.find_by_email(params[:email])

    stream_for user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
