class PasswordResetsController < ApplicationController
  attr_reader :user

  before_action :find_user, :valid_user,
    :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if user
      create_reset_password
    else
      flash.now[:danger] = t ".not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      user.errors.add :password, t(".empty")
      render_edit
    elsif user.update_attributes user_params
      update_user
    else
      render_edit
    end
  end

  private

  def render_edit
    render :edit
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def create_reset_password
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t ".email_sent"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if user
    flash[:success] = t ".falsed"
    redirect_to root_path
  end

  def valid_user
    redirect_to root_url unless check_user
  end

  def check_user
    user && user.activated? && user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t ".expired"
    redirect_to new_password_reset_url
  end

  def update_user
    log_in user
    flash[:success] = t ".reset"
    redirect_to user
  end
end
