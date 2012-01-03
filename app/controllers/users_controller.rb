class UsersController < ApplicationController
  before_filter(:authenticate, :only => [:edit, :update])
  before_filter(:correct_user, :only => [:edit, :update])

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
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
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
  end
end
