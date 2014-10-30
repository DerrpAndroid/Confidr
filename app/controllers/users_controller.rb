class UsersController < ApplicationController
  #before_action :logged_in_user, only: [:index, :edit, :update, :destroy] removed because i added this in application_controller
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build if logged_in?
    @notifications=@user.notifications
    puts @notifications
    @noti_body= @microposts.pluck(:id).sample
    @body=Micropost.find_by_id(@noti_body)
    # puts @body
    # puts @notif
    @rand=rand(1..7)
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Welcome to the Confidr!"
      log_in @user #replace with onboarding screen/video or whatever
      redirect_to @user
    else
      render 'new'
    end
  end
    private

      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end
end
