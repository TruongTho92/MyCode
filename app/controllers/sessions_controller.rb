class SessionsController < ApplicationController
  skip_before_action :login?, only: [:new, :create]
  REMEMBER_ME = { on: 1, off: 0 }.freeze
  def new
    redirect_to root_url if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      if user.activated
        log_in user
        remember_me(user)
        redirect_back_or user
      else
        message = 'Account not activated. Check your email for the activation link.'
        flash[:warning] = message
        render :new
      end
    else
      flash.now[:danger] = t('login_error')
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def remember_me(user)
    params[:session][:remember_me].to_i == REMEMBER_ME[:on] ? remember(user) : forget(user)
  end
end
