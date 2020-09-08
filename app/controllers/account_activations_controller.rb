class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user&.authenticate?(:activation, params[:id]) && !user.activated?
      user.activate
      log_in user
      flash[:success] = t "global.account_activated"
      redirect_to user
    else
      flash[:danger] = t "global.invalid_activation_link"
      redirect_to root_url
    end
  end
end
