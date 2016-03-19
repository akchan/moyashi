Rails.application.routes.draw do
  root 'projects#index'

  # Route for projects controller
  resources :projects do
    patch 'order', as: :labels_order, to: "labels#update_order"
    resources :labels, except: :show, shallow: true

    get 'search/(:exporter)', to: "exporters#show", as: :exporter
    post 'search/(:exporter)', to: "exporters#search"
    post 'export/(:exporter)', to: "exporters#export", as: :export

    get 'records/new/(:spectrum_parser)', to: "records#new", as: :new_record
    get 'records/:id/(renderer/:renderer)', to: 'records#show', as: :record
    resources :records, except: [:index, :new, :show]
  end
  get 'projects/:id/destroy_samples', to: 'projects#destroy_samples_show', as: :project_destroy_samples
  post 'projects/:id/destroy_samples', to: 'projects#destroy_samples'
  get 'projects/:id/confirm_deleting', to: 'projects#confirm_deleting', as: :project_confirm_deleting


  get 'analysis/:analysis', to: 'analysis#show', as: :analysis
  post 'analysis/:analysis', to: 'analysis#analyze'

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
