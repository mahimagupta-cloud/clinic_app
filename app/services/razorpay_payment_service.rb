class RazorpayPaymentService
  def self.create_order(appointment)
    payment = appointment.payment || appointment.build_payment(
      amount: appointment.doctor.consultation_fee,
      status: :pending
    )

    payment.save!

    order = Razorpay::Order.create(
      amount: (payment.amount * 100).to_i,
      currency: "INR",
      receipt: "appointment_#{appointment.id}"
    )

    payment.update!(
      gateway_order_id: order.id
    )

    payment
  end

  def self.verify_payment(
    payment:,
    razorpay_payment_id:,
    razorpay_order_id:,
    razorpay_signature:
  )
    unless payment.gateway_order_id == razorpay_order_id
      raise Razorpay::SignatureVerificationError,
            "Razorpay order does not match payment"
    end

    Razorpay::Utility.verify_payment_signature(
      {
        razorpay_order_id: razorpay_order_id,
        razorpay_payment_id: razorpay_payment_id,
        razorpay_signature: razorpay_signature
      }
    )

    payment.update!(
      gateway_payment_id: razorpay_payment_id,
      status: :completed
    )

    payment
  end
end