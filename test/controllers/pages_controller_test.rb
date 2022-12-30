require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pages_index_url
    assert_response :success
  end

  test "should get error" do
    assert_raise ArgumentError do
      get pages_error_url
    end
  end

  # run this test with:
  #   spring stop && TEST_USING_CACHE=true rails test test/controllers/pages_controller_test.rb -n test_throttle
  def test_throttle
    skip unless ENV["TEST_USING_CACHE"]
    # do not run this test in the same time as other tests since we it will
    # affect Rack::Attack which is enabled by default
    with_clean_caching do
      assert_equal "ActiveSupport::Cache::MemoryStore", Rails.cache.class.name

      Rack::Attack::THROTTLED_REQUESTS_COUNT_LIMIT.times do
        get pages_test_throttle_path
        assert_select '[data-test=test-throttle]', "hello"
      end
      get pages_test_throttle_path
      assert_match "Retry later", response.body
    end
  end
end
