require "test_helper"

class TransactionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
    assert_not_nil assigns(:transaction)
  end

end
