class AddPaymentTypeIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_type_id, :integer

    Order.all.each do |order|
  		order.payment_type_id = (PaymentType.find_by name: order.pay_type || PaymentType.create(:name => order.pay_type)).id
  		order.save!
  	end  	

  	remove_column :orders, :pay_type
  end
end
