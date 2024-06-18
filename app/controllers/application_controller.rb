
C_NOT_FOUND = 404

class ApplicationController < ActionController::API
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

  protected
    def save_gif(gifable, gif_url, original_gif_url)
      gifable.gif.attach(
        io: URI.parse(gif_url).open,
        filename: gif_url.split('/').last
      )

      gifable.original_gif_url = original_gif_url
    end
end
