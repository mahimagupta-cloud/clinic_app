class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.doctor?
      doctor_dashboard_path
    elsif resource.patient?
      patient_dashboard_path
    else
      root_path
    end
  end
end
