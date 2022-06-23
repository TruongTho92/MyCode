class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show;end

  # GET /comments/new
  def new
    message = Comment::CommentCreate.new(params[:content],
                                          current_user.id,
                                          params[:micropost_id]).execute!
    flash[:danger] = message unless message.nil?
    redirect_back fallback_location: root_path
  end

  # GET /comments/1/edit
  def edit;end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    check, message = Comment::CommentDestroy.new(params[:id]).execute!
    status = check ? :success : :danger
    flash[status] = message
    redirect_to root_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end
end
