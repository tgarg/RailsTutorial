require 'spec_helper'

describe Micropost do
  before(:each) do
	@user = Factory(:user)
	@attr = { :content => "This is content" }
  end

  it "should create a new instance given valid attributes" do
	@user.microposts.create!(@attr)
  end

  describe "User associations" do
	before(:each) do
		@micropost = @user.microposts.create(@attr)
	end

	it "should respond to the user attribute" do
		@micropost.should respond_to(:user)
	end

	it "should have the right user associated" do
		@micropost.user.should == @user
		@micropost.user_id.should == @user.id
	end
  end

  describe "validations" do

	it "should require a user id" do
		Micropost.new(@attr).should_not be_valid
	end

	it "should not be longer than 140 characters" do
		@user.microposts.build(:content => 'a' * 141).should_not be_valid
	end
	
	it "should require non-blank content" do
		@user.microposts.build(:content => " ").should_not be_valid
	end
  end
end
