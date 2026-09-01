
class PrescriptionItemsController < ApplicationController
  before_action :set_appointment
  before_action :set_consultation
  before_action :set_prescription
  before_action :set_prescription_item, only: [ :destroy ]

  def new
    @prescription_item = @prescription.prescription_items.build
  end

  def create
    @prescription_item = @prescription.prescription_items.build(
      prescription_item_params
    )

    if @prescription_item.save
      redirect_to appointment_consultation_prescription_path(
        @appointment,
        @consultation
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @prescription_item.destroy

    redirect_to appointment_consultation_prescription_path(
      @appointment,
      @consultation
    )
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end

  def set_consultation
    @consultation = @appointment.consultation
  end

  def set_prescription
    @prescription = @consultation.prescription
  end

  def set_prescription_item
    @prescription_item =
      @prescription.prescription_items.find(params[:id])
  end

  def prescription_item_params
    params.require(:prescription_item).permit(
      :medicine_name,
      :dosage,
      :frequency,
      :duration,
      :instructions
    )
  end
end
