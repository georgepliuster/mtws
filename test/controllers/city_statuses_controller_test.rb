require 'test_helper'

class CityStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @city_status = city_statuses(:one)
  end

  test "should get index" do
    get city_statuses_url
    assert_response :success
  end

  test "should get new" do
    get new_city_status_url
    assert_response :success
  end

  test "should create city_status" do
    assert_difference('CityStatus.count') do
      post city_statuses_url, params: { city_status: { city_id: @city_status.city_id, status: @city_status.status } }
    end

    assert_redirected_to city_status_url(CityStatus.last)
  end

  test "should show city_status" do
    get city_status_url(@city_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_city_status_url(@city_status)
    assert_response :success
  end

  test "should update city_status" do
    patch city_status_url(@city_status), params: { city_status: { city_id: @city_status.city_id, status: @city_status.status } }
    assert_redirected_to city_status_url(@city_status)
  end

  test "should destroy city_status" do
    assert_difference('CityStatus.count', -1) do
      delete city_status_url(@city_status)
    end

    assert_redirected_to city_statuses_url
  end
end
