require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should return the correct user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the correct title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a gravatar profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end



  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
    	get 'new'
    	response.should have_selector("title", :content => "Sign up")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input#user_name")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input#user_email")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input#user_password")
    end

    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input#user_password_confirmation")
    end
  end

  describe "GET 'edit'"do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user.id
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user.id
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the gravatar image" do
      get :edit, :id => @user.id
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email =>"", :password =>"",:password_confirmation=>"" }
      end

      it "should render the edit page" do
        put :update,  :id => @user.id, :user => @attr
        response.should render_template(:edit)
      end

      it "should have the right title" do
        put :update, :id => @user.id, :user => @attr
        response.should have_selector('title', :content => "Edit user")
      end
    end
    describe "success" do

      before(:each) do
        @attr = { 
          :name => "Tushar Garg10",
          :email => "tgarg100@uci.edu",
          :password => "foobar",
          :password_confirmation => "foobar"
        }
      end    
      
      it "should redirect to the profile page" do
        put :update, :id => @user.id, :user => @attr
        response.should redirect_to(user_path(@user.id))
      end

      it "should update the user's profile" do
        put :update, :id => @user.id, :user => @attr
        @user.reload
        @user.email.should == @attr[:email]
        @user.name.should == @attr[:name]
      end

      it "should have a flash message" do
        put :update, :id => @user.id, :user => @attr
        flash[:success].should =~ /updated/i 
      end
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email =>"", :password =>"",:password_confirmation=>"" }
      end

      it "should not create a new user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User,:count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content=>"Sign up")
      end

      it "should re-render the new page" do
        post :create, :user => @attr
        response.should render_template(:new)
      end
    end

    describe "Success" do
      before(:each) do
        @attr = { 
          :name => "Tushar Garg",
          :email => "tgarg@uci.edu",
          :password => "foobar",
          :password_confirmation => "foobar"
        }
      end

      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User,:count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
end
