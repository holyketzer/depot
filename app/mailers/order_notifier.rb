class OrderNotifier < ActionMailer::Base
  default from: "sale@charodiyka.ru"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notofier.received.subject
  #
  def received(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notofier.shipped.subject
  #
  def shipped(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

  def ship_date_changed(order)
    @order = order

    mail to: order.email, subject: 'Ship date was changed'
  end

  def log_error(msg)
    @msg = msg

    mail to: "admin@depot.com", subject: 'Error occured in depot application.'
  end
end
