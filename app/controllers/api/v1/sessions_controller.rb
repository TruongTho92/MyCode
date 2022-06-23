class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :verify_token
  REMEMBER_ME = { on: 1, off: 0 }.freeze

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      if user.activated
        log_in(user)
        user.generate_token
        set_api_token(user)
        remember_me(user)
        render json: success_message('Successfully', ActiveModelSerializers::SerializableResource.new(user, each_serializer: UsersSerializer))
      else
        message = "Account not activated. Check your email for the activation link."
        render json: error_message(message)
      end
    else
      render json: error_message('Invalid email/password combination')
    end
  end

  private

  def remember_me(user)
    params[:remember_me].to_i == REMEMBER_ME[:on] ? remember(user) : forget(user)
  end
end