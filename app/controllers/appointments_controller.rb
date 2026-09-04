class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [ :show, :edit, :update ]

  def index
    @appointments = Appointment.all
  end

  def show
  end

  def new
    puts "doctor_id: #{params[:doctor_id]}"
    puts "scheduled_at: #{params[:scheduled_at]}"
    @appointment = Appointment.new(
      doctor_id: params[:doctor_id],
      scheduled_at: params[:scheduled_at]
    )
  end
  def slots
    @doctor = Doctor.find(params[:doctor_id])
    @date = Date.parse(params[:date])

    @availability = @doctor.doctor_availabilities.find_by(
      date: @date
    )

    @slots = []

    if @availability
      start_time = @availability.start_time
      end_time = @availability.end_time

      current_time = start_time

      while current_time < end_time
        scheduled_at = Time.zone.local(
          @date.year,
          @date.month,
          @date.day,
          current_time.hour,
          current_time.min
        )

        booked = Appointment.exists?(
          doctor_id: @doctor.id,
          scheduled_at: scheduled_at
        )

        @slots << {
          time: scheduled_at,
          booked: booked
        }

        current_time += 30.minutes
      end
    end
  end

  def create
    @appointment = Appointment.new(appointment_params)

    @appointment.patient = current_user.patient
    @appointment.status = :scheduled

    begin
      if @appointment.save
        redirect_to @appointment, notice: "Appointment was successfully booked."
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      @appointment.errors.add(
        :scheduled_at,
        "has already been booked. Please choose another slot."
      )

      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def book
    @doctor = Doctor.find(params[:doctor_id])
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: "Appointment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    @appointment = current_user.patient.appointments.find(params[:id])

    if @appointment.scheduled? && @appointment.scheduled_at > Time.current
      @appointment.update(status: :cancelled)

      redirect_to patient_dashboard_path,
                  notice: "Appointment cancelled successfully."
    else
      redirect_to patient_dashboard_path,
                  alert: "This appointment cannot be cancelled."
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(
      :doctor_id,
      # :patient_id,
      :scheduled_at,
      :status
    )
  end
end
