class PasswordResetsController < ApplicationController
  skip_before_action :login?, only: [:new, :create, :edit, :update]
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new;end

  def edit;end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t('send_mail.email_reset.')
      redirect_to login_path
    else
      flash.now[:danger] = t('send_mail.email_not_found.')
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t('send_mail.password_empty'))
      render :edit
    elsif @user.update(user_params)
      flash[:info] = t('send_mail.reset_success')
      redirect_to(login_path)
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if (@user && @user.activated && @user.authenticated?(:reset, params[:id]))
    redirect_to(root_url)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t('send_mail.email_expired')
    redirect_to(new_password_reset_url)
  end
end