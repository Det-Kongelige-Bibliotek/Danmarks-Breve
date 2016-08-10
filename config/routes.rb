Rails.application.routes.draw do
  
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new

  # Rails does not accept dots in the ids, as it appends :format in every rule (.xml, .html etc)
  # So in constraints, we add this regex for the id (that doesn't allow * in the id), so we
  # can override the default Rails functionality.
  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog', constraints: {:id => /[^\*]+/} do
    concerns :searchable
    concerns :range_searchable

  end

  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  # Rails does not accept dots in the ids, as it appends :format in every rule (.xml, .html etc)
  # So in constraints, we add this regex for the id (that doesn't allow * in the id), so we
  # can override the default Rails functionality.
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog', constraints: {:id => /[^\*]+/} do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

 # Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
 #   get "/pages/:page" => "pages#show"
 # end

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
