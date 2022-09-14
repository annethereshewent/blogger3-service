class Api::V1::Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |user|
      if user.errors.empty?
        UsersChannel.broadcast_to(user, { confirmed: true })
      else
        UsersChannel.broadcast_to(user, { confirmed: false })
      end

      sleep 2

      return redirect_to ENV["BLOGGER_CLIENT_URL"]
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
