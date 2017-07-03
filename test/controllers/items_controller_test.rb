require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = Item.create(
            item_id:"Abc123", 
            property_type:"Casa",
            url:"https://www.stagingeb.com/mx/inmueble/1483-casa-en-cuauhtemoc-hipodromo-condesa?utm_source=Trovit",
            title:"Casa en renta",
            content:"Bella casa en renta",
            type:"For sale",
            agency:"Century21",
            currency:"USD",
            price:"8000",
            period:"",
            date:"02/27/2017",
            time:"00:00",
            status:"active"
    )
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
      post items_url, params: { item: { agency: @item.agency, content: @item.content, date: @item.date, itemId: @item.item_id, price: @item.price, property_type: @item.property_type, time: @item.time, title: @item.title, type: @item.type, url: @item.url } }
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
    patch item_url(@item), params: { item: { agency: @item.agency, content: @item.content, date: @item.date, itemId: @item.item_id, price: @item.price, property_type: @item.property_type, time: @item.time, title: @item.title, type: @item.type, url: @item.url } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
