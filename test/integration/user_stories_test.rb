require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    payment_type = PaymentType.first

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
    	order: { 
    		name: "Alex Emelyanov", 
    		address: "Efimova 1/4", 
    		email: "holyketzer@gmail.com", 
    		payment_type_id: payment_type.id }

	assert_response :success
	assert_template "index"
	cart = Cart.find(session[:cart_id])
	assert_equal 0, cart.line_items.size

	orders = Order.all
	assert_equal 1, orders.size
	order = orders[0]

	assert_equal "Alex Emelyanov", order.name
	assert_equal "Efimova 1/4", order.address
	assert_equal "holyketzer@gmail.com", order.email
	assert_equal payment_type.id, order.payment_type_id

	assert_equal 1, order.line_items.size
	line_item = order.line_items[0]
	assert_equal ruby_book, line_item.product

	mail = ActionMailer::Base.deliveries.last
	assert_equal ["holyketzer@gmail.com"], mail.to
	assert_equal 'sale@charodiyka.ru', mail[:from].value
	assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "admin change order ship date" do
    order = orders(:one)
    assert_nil order.ship_date
    new_ship_date = DateTime.now.to_date

    get edit_order_path(order.id)
    assert_response :success
    assert_template "edit"

    put_via_redirect order_path(order.id),
        order: { 
            name: order.name, 
            address: order.address, 
            email: order.email, 
            payment_type_id: order.payment_type.id,
            ship_date: new_ship_date
        }

    assert_response :success
    assert_template "show"

    updated_order = Order.find(order.id)

    assert_equal new_ship_date, updated_order.ship_date
    assert_equal updated_order.name, order.name
    assert_equal updated_order.address, order.address
    assert_equal updated_order.email, order.email
    assert_equal updated_order.payment_type, order.payment_type

    mail = ActionMailer::Base.deliveries.last
    assert_equal [order.email], mail.to
    assert_equal 'sale@charodiyka.ru', mail[:from].value
    assert_equal "Ship date was changed", mail.subject
    assert_match /#{order.ship_date}/, mail.body.encoded
  end
end
