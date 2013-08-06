json.title @product.title
json.updated @latest_order.try(:updated_at)


json.orders @product.orders do |order|
  json.extract! order, :id, :address, :pay_type
  
  json.line_items order.line_items do |line_item|
  	json.title line_item.product.title
  	json.quantity line_item.quantity
  	json.price number_to_currency line_item.total_price
  end
  json.total_price number_to_currency order.line_items.map(&:total_price).sum
        
  json.author { json.extract! order, :name, :email }
end