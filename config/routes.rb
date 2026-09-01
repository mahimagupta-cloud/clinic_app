Rails.application.routes.draw do
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

  get "up" => "rails/health#show", as: :rails_health_check
end
