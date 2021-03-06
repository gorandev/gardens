Gardens::Application.routes.draw do
  resources :s3_uploads

  devise_for :users, :controllers => { :sessions => "users/sessions" }

  constraints(:subdomain => "app") do
    root :to => 'saved_reports#show_all'
    get 'products/prices'      
    match 'products/pagina_producto(/:id)' => 'products#pagina_producto', :as => 'pagina_producto'
    match 'products/categorias' => 'products#categorias', :as => 'pagina_categorias'
    match 'products/vendors' => 'products#vendors', :as => 'pagina_vendors'
    match 'products/retailers' => 'products#retailers', :as => 'pagina_retailers'
    get 'saved_reports/show_all'  
    get 'sales/ver'
    
    match 'items/productizador' => 'items#productizador', :as => 'pagina_productizador'
    match 'sales/cargapromos' => 'sales#cargapromos', :as => 'pagina_cargapromos'
    match 'sales/eliminar' => 'sales#eliminar', :as => 'pagina_eliminarpromo'

    resources :saved_reports, :defaults => { :format => :json }
    resources :alerts

    scope "/admin" do
        match 'users/reset_password' => 'users#reset_password', :defaults => { :format => :json }
        match 'users/reset_password_by_mail' => 'users#reset_password_by_mail', :defaults => { :format => :json }
        resources :users
    end
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

    get 'items/ignore'
    get 'items/desvincular'
    post 'items/add_aws_filename'
    match 'items/link_product' => 'items#link_product', :defaults => { :format => :json }
    match 'items/search' => 'items#search', :defaults => { :format => :json }
    resources :items, :defaults => { :format => :json }

    match 'products/set_aws_filename' => 'products#set_aws_filename', :defaults => { :format => :json }
    match 'products/get_dates' => 'products#get_dates', :defaults => { :format => :json }
    match 'products/search' => 'products#search', :defaults => { :format => :json }
    match 'products/search_productizador' => 'products#search_productizador', :defaults => { :format => :json }
    match 'products/create_productizador' => 'products#create_productizador', :defaults => { :format => :json }

    match 'products/get_avg_prices' => 'products#get_avg_prices', :defaults => { :format => :json }

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
    match 'sales/create_cargapromos' => 'sales#create_cargapromos', :defaults => { :format => :json }
    match 'sales/update_cargapromos' => 'sales#update_cargapromos', :defaults => { :format => :json }
    resources :sales, :defaults => { :format => :json }

    get 'alerts/create'
    get 'alerts/destroy'
    resources :alerts, :defaults => { :format => :json }
  end
end