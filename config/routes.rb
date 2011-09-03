Gardens::Application.routes.draw do

  resources :events, :defaults => { :format => :json }

  match 'currencies/search' => 'currencies#search', :defaults => { :format => :json }
  resources :currencies, :defaults => { :format => :json }
  
  match 'countries/search' => 'countries#search', :defaults => { :format => :json }
  resources :countries, :defaults => { :format => :json }
  
  match 'property_values/search' => 'property_values#search', :defaults => { :format => :json }
  resources :property_values, :defaults => { :format => :json }
  
  match 'product_types/search' => 'product_types#search', :defaults => { :format => :json }
  resources :product_types, :defaults => { :format => :json }
  
  match 'retailers/search' => 'retailers#search', :defaults => { :format => :json }
  resources :retailers, :defaults => { :format => :json }
  
  match 'prices/search' => 'prices#search', :defaults => { :format => :json }
  resources :prices, :defaults => { :format => :json }

  match 'items/search' => 'items#search', :defaults => { :format => :json }
  resources :items, :defaults => { :format => :json }
  
  get 'products/prices'
  
  match 'products/search' => 'products#search', :defaults => { :format => :json }
  resources :products, :defaults => { :format => :json }

  match 'properties/product_type/:id' => 'properties#get_by_product_type', 
    :as => :get_properties_by_product_type, :defaults => { :format => :json }
  match 'properties/search' => 'properties#search', :defaults => { :format => :json }
  resources :properties, :defaults => { :format => :json }
  
  match 'words/search' => 'words#search', :defaults => { :format => :json }
  resources :words, :defaults => { :format => :json }
  
  match 'misspellings/search' => 'misspellings#search', :defaults => { :format => :json }
  resources :misspellings, :defaults => { :format => :json }
  
  match 'no_words/search' => 'no_words#search', :defaults => { :format => :json }
  resources :no_words, :defaults => { :format => :json }
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
