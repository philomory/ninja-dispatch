require 'test_helper'

class MissionsControllerTest < ActionController::TestCase
  
  test "should show mission" do
    get :show, :id => Mission.make.to_param
    assert_response :success
    assert_not_nil assigns(:mission)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:missions)
  end

  test "not logged in, should not get new" do
    get :new, :ninja_id => Ninja.make.to_param
    assert_redirected_to login_url
    assert_not_nil flash[:notice] 
  end

  test "logged in, should get new for own ninja" do
    log_in
    ninja = Ninja.make(:user => current_user)
    get :new, :ninja_id => ninja.to_param
    assert_response :success
    assert_nil flash[:notice]
  end
  
  test "logged in, should not get new for other's ninja" do
    log_in
    get :new, :ninja_id => Ninja.make.to_param
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end

  test "not logged in, should not create mission" do
    ninja = Ninja.make
    mission = Mission.plan(:ninja => ninja)
    assert_no_difference('Mission.count') do
      post :create, :mission => mission, :ninja_id => ninja.to_param
    end
    
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
  end
  
  test "should not get new for a ninja already on a mission" do
    log_in
    ninja = Ninja.make(:user => current_user)
    Mission.make(:ninja => ninja)
    post :new, :ninja_id => ninja.to_param
    
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end
  
  test "logged in, should create mission for own ninja" do
    log_in
    ninja = Ninja.make(:user => current_user)
    mission = Mission.plan(:ninja => ninja)
    assert_difference('Mission.count') do
      post :create, :mission => mission, :ninja_id => ninja.to_param
    end

    assert_redirected_to mission_path(assigns(:mission))
  end

  test "logged in, should not create mission for other's ninja" do
    log_in
    ninja = Ninja.make
    mission = Mission.plan(:ninja => ninja)
    assert_no_difference('Mission.count') do
      post :create, :mission => mission, :ninja_id => ninja.to_param
    end
    
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end
  
  test "should not create missin for a ninja already on a mission" do
    log_in
    ninja = Ninja.make(:user => current_user)
    Mission.make(:ninja => ninja)
    mission = Mission.plan(:ninja => ninja)
    assert_no_difference('Mission.count') do
      post :create, :mission => mission, :ninja_id => ninja.to_param
    end
    
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end

end
