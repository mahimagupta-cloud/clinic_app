require "test_helper"

class PatientControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get patient_dashboard_url
    assert_response :success
  end
end
