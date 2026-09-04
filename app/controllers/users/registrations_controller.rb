class Users::RegistrationsController < Devise::RegistrationsController
  def new
    session[:signup_role] = params[:role] if params[:role].present?
    super
  end

  def create
    role = session[:signup_role]

    build_resource(sign_up_params)

    resource.role = role == "doctor" ? :doctor : :patient

    if resource.save

      if resource.doctor?
        Doctor.create!(
          user: resource,
          name: params[:doctor][:name],
          specialization: params[:doctor][:specialization],
          experience: params[:doctor][:experience],
          bio: params[:doctor][:bio],
          consultation_fee: params[:doctor][:consultation_fee]
        )
      else
        Patient.create!(
          user: resource,
          name: params[:patient][:name],
          phone: params[:patient][:phone],
          email: resource.email
        )
      end

      sign_up(resource_name, resource)

      session.delete(:signup_role)

      if resource.doctor?
        redirect_to doctor_dashboard_path
      else
        redirect_to patient_dashboard_path
      end

    else
      clean_up_passwords resource
      render :new, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordInvalid => e
    resource.errors.add(:base, e.message)
    clean_up_passwords resource
    render :new, status: :unprocessable_entity
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
