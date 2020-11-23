require 'test_helper'

class MarketsControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get markets_top_url
    assert_response :success
  end

end
