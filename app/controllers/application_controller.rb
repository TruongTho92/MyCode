class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale
  before_action :login?
  WillPaginate.per_page = 7

  

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def login?
    unless logged_in?
      flash[:danger] = t("user.login")
      store_location
      redirect_to login_url
    end

  end
end
