require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end
  
  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a sign up page at '/signup'" do
  	get '/signup'
  	response.should have_selector('title', :content => "Sign up")
  end

  it "Should have the right links in the layout" do
  	visit root_path
  	click_link "about"
  	response.should have_selector('title', :content => "About")
  	click_link "Help"
  	response.should have_selector('title', :content => "Help")
  	click_link "Contact"
  	response.should have_selector('title', :content => "Contact")
  	click_link "Home"
  	response.should have_selector('title', :content => "Home")
  	click_link "Sign up now!"
  	response.should have_selector('title', :content => "Sign up")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end

  describe "when signed in" do

    it "should have a sign out link" do
      integration_sign_in(Factory(:user))
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end

    it "should have a profile link" do
      integration_sign_in(Factory(:user))
      visit root_path
      response.should have_selector("a", :href => user_path(@user.id),
                                         :content => "Profile")
    end

    it "should have a settings link" do
      integration_sign_in(Factory(:user))
      visit root_path
      response.should have_selector("a", :href => edit_user_path(@user.id),
                                         :content => "Settings")
    end    

    it "should have a users link" do
      integration_sign_in(Factory(:user))
      visit root_path
      response.should have_selector("a", :href => users_path,
                                         :content => "Users")
    end   
  end
end
