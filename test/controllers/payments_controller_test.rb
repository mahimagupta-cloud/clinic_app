require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get payments_show_url
    assert_response :success
  end

  test "should get verify" do
    get payments_verify_url
    assert_response :success
  end
end
