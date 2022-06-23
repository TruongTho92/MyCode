class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build
    # @feed_items = current_user.feed.paginate(page: params[:page]).newest
    @feed_items = MicropostSearch.new(params[:search], params[:page]).execute!
  end

  def help; end

  def contact; end
end
