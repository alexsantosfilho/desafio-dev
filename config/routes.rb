Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount MissionControl::Jobs::Engine, at: "/jobs"
  mount ActionCable.server => "/cable"

  # root "transactions#index"
  root "pages#home"
  get "dashboard", to: "pages#dashboard"

  namespace :api do
    namespace :v1 do
      resource :cnab, only: [] do
        post "import", to: "cnab#import", as: "import"
      end
  resources :transactions, only: [ :index, :create ]
      post "import", to: "transactions#import", as: "import_transactions"
    end
  end
  get "/auth/failure" => "sessions/omni_auths#failure", as: :omniauth_failure
  get "/auth/:provider/callback", to: "sessions#omniauth", as: :omniauth_callback

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
