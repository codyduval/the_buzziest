require 'test_helper'

class BuzzPostsControllerTest < ActionController::TestCase
  setup do
    @buzz_post = buzz_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buzz_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buzz_post" do
    assert_difference('BuzzPost.count') do
      post :create, buzz_post: { buzz_source_name: @buzz_post.buzz_source_name, post_content: @buzz_post.post_content, post_date_time: @buzz_post.post_date_time, post_uri: @buzz_post.post_uri, post_weight: @buzz_post.post_weight, scanned_flag: @buzz_post.scanned_flag }
    end

    assert_redirected_to buzz_post_path(assigns(:buzz_post))
  end

  test "should show buzz_post" do
    get :show, id: @buzz_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @buzz_post
    assert_response :success
  end

  test "should update buzz_post" do
    put :update, id: @buzz_post, buzz_post: { buzz_source_name: @buzz_post.buzz_source_name, post_content: @buzz_post.post_content, post_date_time: @buzz_post.post_date_time, post_uri: @buzz_post.post_uri, post_weight: @buzz_post.post_weight, scanned_flag: @buzz_post.scanned_flag }
    assert_redirected_to buzz_post_path(assigns(:buzz_post))
  end

  test "should destroy buzz_post" do
    assert_difference('BuzzPost.count', -1) do
      delete :destroy, id: @buzz_post
    end

    assert_redirected_to buzz_posts_path
  end
end
