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

  test "not logged in, should not get new without ninja" do
    get :new
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
  end

  test "not logged in, should not get new with ninja" do
    get :new, :ninja_id => Ninja.make.to_param
    assert_redirected_to login_url
    assert_not_nil flash[:notice] 
  end
  
  test "logged in, should get new without ninja if use has available ninja" do
    log_in
    Ninja.make(:user => current_user)
    get :new
    assert_response :success
    assert_nil flash[:notice]
  end
  
  test "logged in, should not get new without ninja if user has no ninjas" do
    log_in
    get :new
    assert_redirected_to new_user_ninja_url(current_user)
    assert_not_nil flash[:notice]
  end
  
  test "logged in, should not get new without ninja if user has ninjas, but they are all busy" do
    log_in
    ninja = Ninja.make(:user => current_user)
    Mission.make(:ninja => ninja)
    get :new
    assert_response :redirect
    assert_not_nil flash[:notice]
  end

  test "logged in, should get new with own ninja" do
    log_in
    ninja = Ninja.make(:user => current_user)
    get :new, :ninja_id => ninja.to_param
    assert_response :success
    assert_nil flash[:notice]
  end
  
  test "logged in, should not get new with other's ninja" do
    log_in
    get :new, :ninja_id => Ninja.make.to_param
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end

  test "not logged in, should not create mission" do
    ninja = Ninja.make
    mission = Mission.plan(:ninja => ninja)
    assert_no_difference('Mission.count') do
      post :create, :mission => mission
    end
    
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
  end
  
  test "logged in, should not get new for a ninja already on a mission" do
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
      post :create, :mission => mission
    end

    assert_redirected_to mission_path(assigns(:mission))
  end

  test "logged in, should not create mission for other's ninja" do
    log_in
    ninja = Ninja.make
    mission = Mission.plan(:ninja => ninja)
    assert_no_difference('Mission.count') do
      post :create, :mission => mission
    end
    
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end
  
  test "should not create mission for a ninja already on a mission" do
    log_in
    ninja = Ninja.make(:user => current_user)
    Mission.make(:ninja => ninja)
    mission = Mission.plan(:ninja => ninja)
    assert_no_difference('Mission.count') do
      post :create, :mission => mission
    end
    
    assert_redirected_to user_url(current_user)
    assert_not_nil flash[:notice]
  end
  
  test "should not create mission with non-default state" do
    log_in
    ninja = Ninja.make(:user => current_user)
    mission = Mission.plan(:ninja => ninja)
    mission[:state] = 'succeeded'
    post :create, :mission => mission
    assert_equal 'in_progress', Mission.last.state
  end
  
  test "should not create mission with non-default progress" do
    log_in
    ninja = Ninja.make(:user => current_user)
    mission = Mission.plan(:ninja => ninja)
    mission[:progress] = 100
    post :create, :mission => mission
    assert_equal 0, Mission.last.progress
  end

  test "should not allow user to create mission targetting themself" do
    log_in
    ninja = Ninja.make(:user => current_user)
    mission = Mission.plan(:ninja => ninja, :victim => current_user)
    
    assert_no_difference('Mission.count') do
      post :create, :mission => mission
    end
    assert_redirected_to new_mission_url
  end
  

end
