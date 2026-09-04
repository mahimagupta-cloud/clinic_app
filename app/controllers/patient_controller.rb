class PatientController < ApplicationController
  before_action :authenticate_user!
  before_action :require_patient!

  # Patient Dashboard
  def dashboard
    @patient = current_user.patient

    @appointments = @patient.appointments.includes(:doctor)

  @upcoming_appointments = @appointments.where(
  "scheduled_at >= ? AND status = ?",
  Time.current,
  Appointment.statuses[:scheduled]
)

@past_appointments = @appointments.where(
  "scheduled_at < ? OR status IN (?)",
  Time.current,
  Appointment.statuses.values_at(:completed, :cancelled, :no_show)
)
  end

  # Patient list
  def index
  end

  # Patient details
  def show
  end

  # New patient
  def new
  end

  # Edit patient
  def edit
  end

  private

  def require_patient!
    unless current_user.patient?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
