class AppointmentConfirmationMailer < ApplicationMailer
  def confirmation
    @appointment = params[:appointment]
    @patient = @appointment.patient
    @doctor = @appointment.doctor
    @payment = @appointment.payment

    mail(
      to: @patient.email,
      subject: "Appointment Confirmed - Clinic App"
    )
  end
end