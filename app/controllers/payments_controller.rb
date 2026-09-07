class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment

  def show
    @payment = @appointment.payment

    unless @payment&.pending?
      redirect_to @appointment,
                  alert: "This appointment does not require payment."
    end
  end

  def verify
    @payment = @appointment.payment

    unless @payment&.pending?
      render json: { error: "Payment is not pending." }, status: :unprocessable_entity
      return
    end
    RazorpayPaymentService.verify_payment(
   payment: @payment,
   razorpay_payment_id: params[:razorpay_payment_id],
   razorpay_order_id: params[:razorpay_order_id],
   razorpay_signature: params[:razorpay_signature]
   )

   begin
   AppointmentConfirmationMailer
    .with(appointment: @appointment)
    .confirmation
    .deliver_now
   rescue StandardError => e
   Rails.logger.error "Confirmation email failed: #{e.class} - #{e.message}"
   end 

 render json: { success: true }

  rescue StandardError => e
  Rails.logger.error "Payment verification error: #{e.class} - #{e.message}"

  render json: {
    error: "Payment verification failed."
  }, status: :unprocessable_entity
  end

  private

  def set_appointment
    @appointment = current_user.patient.appointments.find(params[:appointment_id])
  end
end