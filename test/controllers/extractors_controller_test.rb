require 'test_helper'

class ExportersControllerTest < ActionController::TestCase
  setup do
    @exporter = exporters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exporters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exporter" do
    assert_difference('Exporter.count') do
      post :create, exporter: {  }
    end

    assert_redirected_to exporter_path(assigns(:exporter))
  end

  test "should show exporter" do
    get :show, id: @exporter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exporter
    assert_response :success
  end

  test "should update exporter" do
    patch :update, id: @exporter, exporter: {  }
    assert_redirected_to exporter_path(assigns(:exporter))
  end

  test "should destroy exporter" do
    assert_difference('Exporter.count', -1) do
      delete :destroy, id: @exporter
    end

    assert_redirected_to exporters_path
  end
end
