class MicropostsController < ApplicationController
  before_action :correct_user, only: :destroy
  def index;end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page])
      render "static_pages/home"
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost
    flash[:danger] = "Micropost invalid"
    redirect_to request.referrer || root_url
  end
end
