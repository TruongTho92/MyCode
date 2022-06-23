class LikesController < ApplicationController
  before_action :micropost
  before_action :like, only: [:destroy]
  def create
    if already_liked?
      flash[:danger] = "You can't like more than once"
    else
      @micropost.likes.create(user_id: current_user.id)
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    if already_liked?
      @like.destroy
    else
      flash[:notice] = "Cannot unlike"
    end
    redirect_back fallback_location: root_path
  end

  private
  def micropost
    @micropost = Micropost.find(params[:micropost_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, micropost_id:
    params[:micropost_id]).exists?
  end

  def like
    @like = @micropost.likes.find(params[:id])
  end
end
