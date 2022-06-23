class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :login?, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]

  # GET /users or /users.json
  def index
    @users = UserSearch.new(params[:search], params[:page]).execute!
  end

  # GET /users/1 or /users/1.json
  def show
    @microposts = @user.microposts.paginate(page: params[:page]).newest
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by(id: params[:id])
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t("user.check_mail")
      redirect_to login_path
    else
      render :new
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = t ("user.update_success")
      redirect_to users_path  
    else
      render "edit"
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    user = User.find_by(id: params[:id])
    if user&.destroy
      flash[:success] = "User deleted"
    else
      flash[:danger] = "Delete fail!"
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def export
    csv = ExportCSV.new User.all, User::CSV_ATTRIBUTES
    respond_to do |format|
      format.csv { send_data csv.execute!,
        filename: "users.csv" }
    end
  end

  def import
    User.import_file(params[:file])
    redirect_to root_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(user)
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :age, :phone, :date_of_birth, :gender, :password, :password_confirmation)
  end

  def search_params
    params.permit(:search_name)
  end

end
