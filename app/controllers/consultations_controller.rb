class ConsultationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_doctor!

  before_action :set_appointment
  before_action :set_consultation, only: [:show, :edit, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  def index
    @consultation = @appointment.consultation
  end

  def new
    unless @appointment.completed?
      redirect_to appointment_path(@appointment),
                  alert: "Consultation can only be created for completed appointments."
      return
    end

    if @appointment.consultation.present?
      redirect_to appointment_consultation_path(
        @appointment,
        @appointment.consultation
      )
    else
      @consultation = @appointment.build_consultation
    end
  end

  def create
    unless @appointment.completed?
      redirect_to appointment_path(@appointment),
                  alert: "Consultation can only be created for completed appointments."
      return
    end

    @consultation = @appointment.build_consultation(
      consultation_params.merge(
        doctor: @appointment.doctor,
        patient: @appointment.patient
      )
    )

    if @consultation.save
      redirect_to appointment_path(@appointment),
                  notice: "Consultation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @consultation.update(consultation_params)
      redirect_to appointment_path(@appointment),
                  notice: "Consultation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @consultation.destroy

    redirect_to appointment_path(@appointment),
                notice: "Consultation was successfully deleted."
  end

  private

  def require_doctor!
    unless current_user.doctor?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def set_appointment
    @appointment = current_user.doctor.appointments.find(params[:appointment_id])
  end

  def set_consultation
    @consultation = @appointment.consultation
  end

  def consultation_params
    params.require(:consultation).permit(
      :symptoms,
      :diagnosis,
      :notes,
      :fee,
      :visited_at
    )
  end
end
