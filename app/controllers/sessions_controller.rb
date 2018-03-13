class SessionsController < ApplicationController
  attr_reader :user

  def new; end

  def create
    @user = User.find_by email: session_params[:email].downcase
    if user && user.authenticate(session_params[:password])
      login_success
    else
      login_false
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_success
    log_in user
    session_params[:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def login_false
    flash.now[:danger] = t ".invalid"
    render :new
  end
end
