class UsersController < ApplicationController
  attr_reader :user

  before_action :logged_in_user, only: %i(:index, :edit, :update, :destroy,
    :following, :followers)
  before_action :logged_in_user, only: %i(:index, :edit, :update, :destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.activated.paginate page: params[:page],
     per_page: Settings.per_page.maximum
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      user.send_activation_email
      flash[:info] = t ".please"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = user.microposts.paginate page: params[:page]
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    flash[:success] = t ".delete"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find params[:id]
    @users = user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find params[:id]
    @users = user.followers.paginate page: params[:page]
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please"
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:success] = t ".falsed"
    redirect_to root_path
  end
end
