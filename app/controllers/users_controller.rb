class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :edit, :update]
  before_action :require_login, only: [:index, :show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Account created! Welcome!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
  end

  def show
  end

  def edit
    authorize_user_or_admin
  end

  def update
    authorize_user_or_admin
    if @user.update(user_params)
      redirect_to @user, notice: "User updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_user_or_admin
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def authorize_user_or_admin
    unless current_user == @user || current_user&.admin?
      redirect_to root_path, alert: "Not authorized"
    end
  end
end
