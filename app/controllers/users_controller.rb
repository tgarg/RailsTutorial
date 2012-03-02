class UsersController < ApplicationController
  before_filter(:authenticate, :only => [:index, :edit, :update])
  before_filter(:correct_user, :only => [:edit, :update])

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

  private

  def authenticate
    deny_access unless signed_in?
  end

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
end
