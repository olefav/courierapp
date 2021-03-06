require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:order_1)
    @user = users(:test_user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    #Rails::logger.debug @order.inspect + '8885'
    assert_difference('Order.count') do
      post :create, order: { delivered_date: @order.delivered_date, receiver_id: @order.receiver.id, sender_id: @order.sender.id, sum: @order.sum }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { delivered_date: @order.delivered_date, issued_date: @order.issued_date, number: @order.number, receiver_id: @order.receiver_id, sender_id: @order.sender_id, sum: @order.sum }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
