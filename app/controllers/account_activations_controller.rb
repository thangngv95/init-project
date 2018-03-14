class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user_activate user
    else
      user_not_activate
    end
  end

  private

  def user_activate user
    user.activate
    log_in user
    flash[:success] = t ".activate"
    redirect_to user
  end

  def user_not_activate
    flash[:danger] = t ".in_activate"
    redirect_to root_url
  end
end
