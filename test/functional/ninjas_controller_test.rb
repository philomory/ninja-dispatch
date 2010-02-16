require 'test_helper'

class NinjasControllerTest < ActionController::TestCase

  test "should show ninja" do
    get :show, :id => Ninja.make.to_param
    assert_response :success
  end
  
  test "not logged in, should not retire ninja" do
    ninja = Ninja.make
    put :retire, :id => ninja.id
    ninja.reload
    
    assert_equal true, ninja.active?, "ninja.active? should return true"
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
  end
  
  test "logged in, should retire own ninja" do
    log_in
    ninja = Ninja.make(:user => current_user)
    put :retire, :id => ninja.id
    ninja.reload
    
    assert_equal false, ninja.active?, "ninja.active? should return false"
    assert_redirected_to ninja_url(ninja.id)
    
  end
  
  test "logged in, should not retire someone else's ninja" do
    log_in
    ninja = Ninja.make
    put :retire, :id => ninja.id
    ninja.reload
    
    assert_equal true, ninja.active?, "ninja.active? should return true"
    assert_redirected_to ninja_url(ninja.id)
    assert_not_nil flash[:notice]
  end
  
  test "not logged in, should not get new" do
    get :new, :user_id => User.make.to_param
    assert_redirected_to login_url
    assert_not_nil flash[:notice] 
  end
  
  test "logged in, should get new for self" do
    log_in
    get :new, :user_id => current_user.to_param
    assert_response :success
  end
  
  test "logged in, should not get new for others" do
    log_in
    get :new, :user_id => User.make.to_param
    assert_redirected_to new_user_ninja_url(current_user)
    assert_not_nil flash[:notice] 
  end
  
  test "not logged in, should not create ninja" do
    user = User.make
    ninja = Ninja.plan(:user => user)
    assert_no_difference('Ninja.count') do
      post :create, :ninja => ninja, :user_id => user.to_param
    end
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
  end
  
  test "logged in, should create ninja for self" do
    log_in
    ninja = Ninja.plan(:user => current_user)
    assert_difference('Ninja.count') do
      post :create, :ninja => ninja, :user_id => current_user.to_param
    end
    assert_redirected_to ninja_url(assigns(:ninja))
    assert_nil flash[:notice]
  end
  
  test "logged in, should not create ninja for others" do
    log_in
    user = User.make
    ninja = Ninja.plan(:user => user)
    assert_no_difference("Ninja.count") do
      post :create, :ninja => ninja, :user_id => user.to_param
    end
    assert_redirected_to new_user_ninja_url(current_user)
    assert_not_nil flash[:notice]
  end
  
end
