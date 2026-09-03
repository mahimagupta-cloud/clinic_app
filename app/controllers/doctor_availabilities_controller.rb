class DoctorAvailabilitiesController < ApplicationController
  before_action :set_doctor
  before_action :set_availability, only: [ :edit, :update, :destroy ]
  before_action :authenticate_user!
  before_action :require_doctor!

  def index
    @availabilities = @doctor.doctor_availabilities
  end

  def new
    @availability = @doctor.doctor_availabilities.build
  end

  def create
    @availability = @doctor.doctor_availabilities.build(availability_params)

    if @availability.save
      redirect_to doctor_doctor_availabilities_path(@doctor)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @availability.update(availability_params)
      redirect_to doctor_doctor_availabilities_path(@doctor)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @availability.destroy

    redirect_to doctor_doctor_availabilities_path(@doctor)
  end

  private
def set_doctor
  @doctor = current_user.doctor

  unless @doctor && @doctor.id.to_s == params[:doctor_id]
    redirect_to root_path, alert: "Access denied."
  end
end

  def set_availability
    @availability = @doctor.doctor_availabilities.find(params[:id])
  end

  def availability_params
    params.require(:doctor_availability).permit(
      :day_of_week,
      :start_time,
      :end_time
    )
  end
end

def require_doctor!
  unless current_user.doctor?
    redirect_to root_path, alert: "Access denied."
  end
end
