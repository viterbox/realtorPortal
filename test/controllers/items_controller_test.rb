require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post items_url, params: { item: { agency: @item.agency, bathrooms: @item.bathrooms, city: @item.city, cityArea: @item.cityArea, content: @item.content, currency: @item.currency, date: @item.date, floorArea: @item.floorArea, itemId: @item.itemId, latitude: @item.latitude, longitude: @item.longitude, mainPicture: @item.mainPicture, price: @item.price, propertyType: @item.propertyType, region: @item.region, rooms: @item.rooms, time: @item.time, title: @item.title, type: @item.type, unit: @item.unit, url: @item.url } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    patch item_url(@item), params: { item: { agency: @item.agency, bathrooms: @item.bathrooms, city: @item.city, cityArea: @item.cityArea, content: @item.content, currency: @item.currency, date: @item.date, floorArea: @item.floorArea, itemId: @item.itemId, latitude: @item.latitude, longitude: @item.longitude, mainPicture: @item.mainPicture, price: @item.price, propertyType: @item.propertyType, region: @item.region, rooms: @item.rooms, time: @item.time, title: @item.title, type: @item.type, unit: @item.unit, url: @item.url } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
