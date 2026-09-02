Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: "users/registrations"
  }
  root "home#index"
get "patient/dashboard", to: "patient#dashboard", as: :patient_dashboard
get "doctor/dashboard", to: "doctor#dashboard", as: :doctor_dashboard
patch "doctor/appointments/:id/status",
      to: "doctor#update_appointment_status",
      as: :doctor_appointment_status

  get "admin/dashboard",
      to: "admin#dashboard"

  resources :patients

  resources :doctors do
    resources :doctor_availabilities
  end

  resources :appointments do
    get "slots", on: :collection
    get "book", on: :collection

    resources :consultations do
      resource :prescription do
        resources :prescription_items
      end
    end
  end
end
