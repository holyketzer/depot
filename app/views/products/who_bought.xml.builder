xml.instruct!

xml.who_bought do
	xml.title "Who bought #{@product.title}"
	xml.updated @latest_order.try(:updated_at)

	@product.orders.each do |order|
    xml.order do
      xml.id order.id
      xml.address order.address
      xml.pay_type order.pay_type

      order.line_items.each do |item|
        xml.line_item do
          xml.product item.product.title
          xml.quantity item.quantity
          xml.price number_to_currency item.total_price
        end
      end
      xml.total_price number_to_currency order.line_items.map(&:total_price).sum        
      
      xml.author do
        xml.name order.name
        xml.email order.email
      end
    end    
  end
end
