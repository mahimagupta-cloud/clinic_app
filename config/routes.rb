Rails.application.routes.draw do
  get "doctors/index"
  get "doctors/show"
  get "doctors/new"
  get "doctors/edit"
  get "patient/dashboard"
  get "admin/dashboard"

  resources :patients

  resources :appointments do
    get "slots", on: :collection

    resources :consultations do
      resource :prescription do
        resources :prescription_items
      end
    end
  end

  resources :doctors do
    resources :doctor_availabilities
  end
end
