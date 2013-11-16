RoR007::Application.routes.draw do

  resources :grids
  resources :ships
  resources :players
  resources :games
  get "ships/new"

  get "ships/help"
  

  
  get "grids/index"
  get "grids/new"
  get "grids/edit"
  get "games/calculate_hits"
  get "games/save_ships"
  match '/ships/new' => 'ships#new'
  
  

  match '/arrange_ships/:player_id' => 'games#arrange_ships', as: 'arrange_ships'
  match '/play/:player_id' => 'games#play', as: 'play'
  match '/refresh/:player_id(.:format)' => 'games#refresh', as: 'refresh'
  match '/take_turn/:player_id(.:format)' => 'games#take_turn', as: 'take_turn'
  match '/update/:player_id/:x/:y(.:format)' => 'games#update', as: 'update'
  match '/save_ships/:player_id' => 'games#save_ships', as: 'save_ships'
  
  #match '/home' => 'grids#index'

  # The priority is based upon order of creation:
   #first created -> highest priority.

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
