require 'test_helper'

class NeuronsControllerTest < ActionController::TestCase
  setup do
    @neuron = neurons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:neurons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create neuron" do
    assert_difference('Neuron.count') do
      post :create, :neuron => @neuron.attributes
    end

    assert_redirected_to neuron_path(assigns(:neuron))
  end

  test "should show neuron" do
    get :show, :id => @neuron.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @neuron.to_param
    assert_response :success
  end

  test "should update neuron" do
    put :update, :id => @neuron.to_param, :neuron => @neuron.attributes
    assert_redirected_to neuron_path(assigns(:neuron))
  end

  test "should destroy neuron" do
    assert_difference('Neuron.count', -1) do
      delete :destroy, :id => @neuron.to_param
    end

    assert_redirected_to neurons_path
  end
end
