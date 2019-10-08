class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  # before_action :set_user, only: [:show, :edit, :update]
  before_action :set_current_user, except: [:show]

  # def index
  #   @users = User.all
  # end

  def show
    @user = User.find(params[:id])
  end

  # def new
  #   @user = User.new
  # end

  def edit
  end

  # def create
  #   @user = User.new(user_params)
  #
  #   if @user.save
  #     redirect_to @user, notice: 'User was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  def update
    if @user.update(user_params)
      # redirect_to @user, notice: 'User was successfully updated.'
      # Мы придумали такой адрес для сообщений контроллеров
      # Здесь адрес для контроллера events и действия update
      redirect_to @user, notice: I18n.t('controllers.users.updated')
    else
      render :edit
    end
  end

  # def destroy
  #   @user.destroy
  #   redirect_to users_url, notice: 'User was successfully destroyed.'
  # end

  private

  # def set_user
  #   @user = User.find(params[:id])
  # end

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
