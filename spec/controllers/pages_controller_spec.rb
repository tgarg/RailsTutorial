require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title="Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + "Home")
    end

    describe "for signed-in users" do

      before(:each) do
        @user=Factory(:user)
        test_sign_in(@user)
        @micropost=Factory(:micropost, :user => @user)
      end

      it "should have the micropost count in the sidebar" do
        get 'home'
        response.should have_selector('span.microposts')
      end

      it "should not be plural for one micropost" do
        get 'home'
        response.should have_selector('span.microposts', :content => 'micropost')
      end

      it "should properly pluralize the micropost count" do
        Factory(:micropost, :user => @user)
        get 'home'
        response.should have_selector('span.microposts', :content => 'microposts')
      end
      
      it "should paginate the microposts" do
        35.times do
          Factory(:micropost, :user => @user)
        end
        get 'home'
        response.should have_selector('div.pagination')
      end
    end

  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + "Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                                    :content => @base_title + "Help")
    end
  end

end
