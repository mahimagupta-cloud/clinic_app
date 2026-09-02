class HomeController < ApplicationController
  def index
    @doctors = Doctor.all

    if params[:search].present?
      search = "%#{params[:search]}%"

      @doctors = @doctors.where(
        "doctors.name LIKE :search OR doctors.specialization LIKE :search",
        search: search
      )
    end

    if params[:city].present?
      city = "%#{params[:city]}%"

      @doctors = @doctors.joins(:clinic).where(
        "clinics.city LIKE ?",
        city
      )
    end
  end
end
