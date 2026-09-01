
class PrescriptionsController < ApplicationController
  before_action :set_appointment
  before_action :set_consultation

  def show
    @prescription = @consultation.prescription
  end

  def new
    if @consultation.prescription.present?
      redirect_to appointment_consultation_prescription_path(
        @appointment,
        @consultation
      )
    else
      @prescription = @consultation.build_prescription
      @prescription.prescription_items.build
    end
  end

  def create
    @prescription = @consultation.build_prescription(prescription_params)

    if @prescription.save
      redirect_to appointment_consultation_prescription_path(
        @appointment,
        @consultation
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end

  def set_consultation
    @consultation = @appointment.consultation
  end

  def prescription_params
    params.require(:prescription).permit(
      prescription_items_attributes: [
        :medicine_name,
        :dosage,
        :frequency,
        :duration,
        :instructions
      ]
    )
  end
end
