class ConsultationsController < ApplicationController
  before_action :set_appointment
  before_action :set_consultation, only: [ :show, :edit, :update, :destroy ]

  def index
    @consultation = @appointment.consultation
  end

  def new
    if @appointment.consultation.present?
      redirect_to appointment_consultation_path(@appointment, @appointment.consultation)
    else @consultation = @appointment.build_consultation
    end
  end

  def create
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

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
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
