Rails.application.routes.draw do
  root "tenet/pages#landing"

  get "/dashboard"      => "user_dashboard#show", as: 'dashboard'
  get "/locale/satori"  => "locale#satori", as: 'satori_locale'
  get "/locale/eavs"    => "locale#eavs", as: 'eavs_locale'
  get "/about"          => "pages#about", as: 'about_page'

  resources :signed_urls, only: [ :create ]

  resources :elections do
    member do
      post :lock_data
      post :unlock_data
    end

    resources :transaction_logs
    resources :demog_files
    resources :upload_jobs, only: [ :destroy ]

    get '/reports/events_by_locality'           => 'reports#events_by_locality', as: 'events_by_locality_report'
    get '/reports/events_by_locality_by_uocava' => 'reports#events_by_locality_by_uocava', as: 'events_by_locality_by_uocava_report'
    get '/reports/events_by_locality_by_gender' => 'reports#events_by_locality_by_gender', as: 'events_by_locality_by_gender_report'
    get '/reports/voter_demographics_by_locality' => 'reports#voter_demographics_by_locality', as: 'voter_demographics_by_locality_report'
    get '/reports/voter_age_demographics_by_locality' => 'reports#voter_age_demographics_by_locality', as: 'voter_age_demographics_by_locality_report'
    get '/reports/cancellation_reasons_by_locality' => 'reports#cancellation_reasons_by_locality', as: 'cancellation_reasons_by_locality_report'
    get '/reports/registration_rejection_reasons_by_locality' => 'reports#registration_rejection_reasons_by_locality', as: 'registration_rejection_reasons_by_locality_report'
    get '/reports/ballot_rejection_reasons_by_locality' => 'reports#ballot_rejection_reasons_by_locality', as: 'ballot_rejection_reasons_by_locality_report'

    get '/reports/advanced'    => 'reports#advanced', as: 'advanced_report'
    get '/reports/eavs_part_a' => 'reports#eavs_part_a', as: 'eavs_part_a_report'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
