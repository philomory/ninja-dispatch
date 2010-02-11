require 'test_helper'

class MissionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:missions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mission" do
    mission = Mission.plan
    assert_difference('Mission.count') do
      post :create, :mission => mission
    end

    assert_redirected_to mission_path(assigns(:mission))
  end

  test "should show mission" do
    get :show, :id => Mission.make.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Mission.make.to_param
    assert_response :success
  end

  test "should update mission" do
    put :update, :id => Mission.make.to_param, :mission => { }
    assert_redirected_to mission_path(assigns(:mission))
  end

  test "should destroy mission" do
    mission = Mission.make
    assert_difference('Mission.count', -1) do
      delete :destroy, :id => mission.to_param
    end

    assert_redirected_to missions_path
  end
end
