class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user_by_id, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.page(params[:page]).per Settings.users.user.per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "global.account_not_activated"
      redirect_to root_url
    else
      flash.now[:danger] = t "global.flash_new_users_danger"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "global.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "global.update_unsuccess"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "global.user_deleted"
      redirect_to users_url
    else
      flash.now[:danger] = t "global.delete_unsuccessful"
      render :index
    end
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "global.please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def load_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "global.user_not_found"
    redirect_to root_path
  end
end
