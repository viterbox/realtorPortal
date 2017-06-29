require 'test_helper'

class UpdaterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get updater_index_url
    assert_response :success
  end

end
