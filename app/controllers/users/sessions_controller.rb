class Users::SessionsController < Devise::SessionsController
  prepend_before_action :prepare_login_role,
                         only: [:new] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  before_action :set_login_role,
                only: [:create] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  def create
    selected_role = session[:login_role]

    email = params.dig(:user, :email)

    user = User.find_by(email: email)

    if user.present?

      if selected_role == "doctor" && !user.doctor?
        redirect_to doctor_login_path(role: "doctor"),
                    alert: "This account is not registered as a doctor."
        return
      end

      if selected_role == "patient" && !user.patient?
        redirect_to patient_login_path(role: "patient"),
                    alert: "This account is not registered as a patient."
        return
      end

    end

    super
  end

  # Redirect after successful login
  def after_sign_in_path_for(resource)
    if resource.doctor?
      doctor_dashboard_path
    elsif resource.patient?
      patient_dashboard_path
    else
      root_path
    end
  end

  private

  def prepare_login_role
    if params[:role].present?
      session[:login_role] = params[:role]
    end

    if user_signed_in?
      sign_out(:user)
    end
  end

  def set_login_role
    if params[:role].present?
      session[:login_role] = params[:role]
    end
  end
end
