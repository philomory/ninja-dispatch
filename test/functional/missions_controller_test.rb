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

end
