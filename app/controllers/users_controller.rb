class UsersController < ApplicationController
  before_filter(:authenticate, :only => [:index, :edit, :update, :destroy])
  before_filter(:correct_user, :only => [:edit, :update])
  before_filter(:admin_user, :only => :destroy)
  before_filter(:signed_in, :only => [:new, :create])

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def new
  	@title = "Sign up"
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in(@user)
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to user_path(@user.id)
  	else
  		@title = "Sign up"
  		render :new
  		@user.password = ""
  		@user.password_confirmation = ""
  	end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def edit
    # Originally this line needed to be here, but since I added the before_filter,
    # the line has been moved to the method below in the private section, since
    # everything in that method is executed before the contents of this method
    # ----------------------------------
    # @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user.id)
      flash.now[:success] = "Profile updated successfully!"
    else   
      @title = "Edit user" 
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully!"
    redirect_to users_path
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path, :notice => "Access denied.") unless current_user?(@user)
    # Below is a more verbose way of accomplishing the same as the above line
    # -----------------------------
    # if current_user?(@user)
    # else
    #   redirect_to(root_path)
    #   flash[:notice] = "Access denied."
    # end
  end

  def admin_user
    user = User.find(params[:id])
    redirect_to(root_path) unless (current_user.admin? && !current_user?(user))
  end

  def signed_in
    if signed_in?
      redirect_to(root_path)
      flash[:notice] = "You're already signed in dummy!"
    end
  end
end
