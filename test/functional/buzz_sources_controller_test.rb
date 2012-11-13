require 'test_helper'

class BuzzSourcesControllerTest < ActionController::TestCase
  setup do
    @buzz_source = buzz_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buzz_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buzz_source" do
    assert_difference('BuzzSource.count') do
      post :create, buzz_source: { buzz_weight: @buzz_source.buzz_weight, name: @buzz_source.name, uri: @buzz_source.uri }
    end

    assert_redirected_to buzz_source_path(assigns(:buzz_source))
  end

  test "should show buzz_source" do
    get :show, id: @buzz_source
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @buzz_source
    assert_response :success
  end

  test "should update buzz_source" do
    put :update, id: @buzz_source, buzz_source: { buzz_weight: @buzz_source.buzz_weight, name: @buzz_source.name, uri: @buzz_source.uri }
    assert_redirected_to buzz_source_path(assigns(:buzz_source))
  end

  test "should destroy buzz_source" do
    assert_difference('BuzzSource.count', -1) do
      delete :destroy, id: @buzz_source
    end

    assert_redirected_to buzz_sources_path
  end
end
