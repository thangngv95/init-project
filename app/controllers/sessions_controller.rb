class SessionsController < ApplicationController
  attr_reader :user

  def new; end

  def create
    @user = User.find_by email: session_params[:email].downcase
    if user && user.authenticate(session_params[:password])
      if user.activated?
        login_success
      else
        account_not_activate
      end
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
    flash[:info] = t(".welcome_back") + user.name
    session_params[:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def account_not_activate
    message = t ".account_not_active"
    message += t ".check"
    flash[:warning] = message
    redirect_to root_url
  end

  def login_false
    flash.now[:danger] = t ".invalid"
    render :new
  end
end
