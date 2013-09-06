class PaymentType < ActiveRecord::Base
	has_many :orders

	def localized_name
		I18n.t("orders.form.#{name.downcase.sub(' ', '_')}")
	end
end
