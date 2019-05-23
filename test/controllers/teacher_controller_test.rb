require 'test_helper'

class TeacherControllerTest < ActionDispatch::IntegrationTest
  test "should get view" do
    get teacher_view_url
    assert_response :success
  end

end
