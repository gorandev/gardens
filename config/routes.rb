Gardens::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "users/sessions" }

  constraints(:subdomain => "rails") do
    root :to => 'products#prices'
    get 'products/prices'        
    match 'products/pagina_producto(/:id)' => 'products#pagina_producto', :as => 'pagina_producto'
    get 'saved_reports/show_all'  
    get 'sales/ver'

    resources :saved_reports, :defaults => { :format => :json }
  end

  constraints(:subdomain => "api") do
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

    match 'products/get_dates' => 'products#get_dates', :defaults => { :format => :json }
    match 'products/search' => 'products#search', :defaults => { :format => :json }

    get 'products/inicializar_memstore'

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

    resources :media_channel_types, :defaults => { :format => :json }
    resources :media_channels, :defaults => { :format => :json }

    match 'sales/search' => 'sales#search', :defaults => { :format => :json }
    resources :sales, :defaults => { :format => :json }
  end
end