class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user.try :authenticate, params[:session][:password]
      user_activated user
    else
      flash.now[:danger] = t "global.flash_login_danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def checkbox_remember user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def user_activated user
    if user.activated?
      log_in user
      checkbox_remember user
      redirect_back_or user
    else
      flash[:warning] = t "global.account_not_activated"
      redirect_to root_url
    end
  end
end
