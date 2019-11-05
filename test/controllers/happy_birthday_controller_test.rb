require 'test_helper'

class HappyBirthdayControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get happy_birthday_index_url
    assert_response :success
  end

end
