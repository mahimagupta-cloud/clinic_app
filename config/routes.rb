Rails.application.routes.draw do
  root "role#index"

  get "role",
      to: "role#index",
      as: :role_selection

  # Login Routes
  devise_scope :user do
    get "patient/login",
        to: "users/sessions#new",
        as: :patient_login

    get "doctor/login",
        to: "users/sessions#new",
        as: :doctor_login
  end

  devise_for :users,
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions"
    }

  # Patient Dashboard
  get "patient/dashboard",
      to: "patient#dashboard",
      as: :patient_dashboard

  # Doctor Dashboard
  get "doctor/dashboard",
      to: "doctor#dashboard",
      as: :doctor_dashboard

  # Doctor Appointment Status
  patch "doctor/appointments/:id/status",
        to: "doctor#update_appointment_status",
        as: :doctor_appointment_status

  # Admin Dashboard
  get "admin/dashboard",
      to: "admin#dashboard",
      as: :admin_dashboard

  # Patients
  resources :patients,
            controller: "patient",
            only: [ :index, :show, :new, :edit ]

  # Doctors
  resources :doctors,
            controller: "doctor" do
    resources :doctor_availabilities
  end

  # Appointments
  resources :appointments do
    get "slots",
        on: :collection

    get "book",
        on: :collection
    patch "cancel", on: :member

    resources :consultations do
      resource :prescription do
        resources :prescription_items
      end
    end
  end
end
