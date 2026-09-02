class PatientController < ApplicationController
  before_action :authenticate_user!
  before_action :require_patient!

  def dashboard
    @patient = current_user.patient

    @appointments = @patient.appointments.includes(:doctor)

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

  private

  def require_patient!
    unless current_user.patient?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
