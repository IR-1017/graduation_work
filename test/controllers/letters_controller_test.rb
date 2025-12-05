require "test_helper"

class LettersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get letters_index_url
    assert_response :success
  end

  test "should get show" do
    get letters_show_url
    assert_response :success
  end

  test "should get new" do
    get letters_new_url
    assert_response :success
  end

  test "should get create" do
    get letters_create_url
    assert_response :success
  end
end
