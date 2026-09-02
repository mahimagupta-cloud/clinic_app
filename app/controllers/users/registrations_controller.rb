class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        Patient.create!(
          user: resource,
          name: params[:patient][:name],
          phone: params[:patient][:phone],
          email: resource.email
        )
      end
    end
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
