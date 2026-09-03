class DoctorController < ApplicationController
  # Doctor-only actions
  before_action :authenticate_user!, only: [ :dashboard, :update_appointment_status ]
  before_action :require_doctor!, only: [:dashboard, :update_appointment_status] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  # CRUD actions
  before_action :set_doctor, only: [:show, :edit, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets


  # Doctor Dashboard

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
      ["completed", "cancelled", "no_show"] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
    )
  end


  # Doctor List


  def index
    @doctors = Doctor.all
  end




  def show
  end

  def new
    @doctor = Doctor.new
  end


  def create
    @doctor = Doctor.new(doctor_params)

    if @doctor.save
      redirect_to @doctor,
                  notice: "Doctor was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end



  def edit
  end


  def update
    if @doctor.update(doctor_params)
      redirect_to @doctor,
                  notice: "Doctor was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @doctor.destroy

    redirect_to doctors_path,
                notice: "Doctor was successfully deleted."
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


  # Find Doctor
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end


  # Only Doctor can access Doctor Dashboard
  def require_doctor!
    unless current_user.doctor?
      redirect_to root_path,
                  alert: "Access denied."
    end
  end


  # Strong Parameters
  def doctor_params
    params.require(:doctor).permit(
      :clinic_id,
      :name,
      :specialization,
      :experience,
      :bio,
      :consultation_fee
    )
  end
end
