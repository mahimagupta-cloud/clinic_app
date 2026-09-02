class DoctorController < ApplicationController
  before_action :authenticate_user!
  before_action :require_doctor!

  def dashboard
    @doctor = current_user.doctor

    @appointments = @doctor.appointments.includes(:patient)

    @upcoming_appointments = @appointments.where(
      "scheduled_at >= ? AND status = ?",
      Time.current,
      "scheduled"
    )

    @past_appointments = @appointments.where(
      "scheduled_at < ? OR status IN (?)",
      Time.current,
      [ "completed", "cancelled", "no_show" ]
    )
  end

  def update_appointment_status
    appointment = current_user.doctor.appointments.find(params[:id])

    if appointment.update(status: params[:status])
      redirect_to doctor_dashboard_path,
                  notice: "Appointment status updated."
    else
      redirect_to doctor_dashboard_path,
                  alert: appointment.errors.full_messages.to_sentence
    end
  end

  private

  def require_doctor!
    unless current_user.doctor?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
