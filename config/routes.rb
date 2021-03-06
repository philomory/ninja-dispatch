ActionController::Routing::Routes.draw do |map|
  map.resources :missions

  map.activate '/activate/:activation_code', :action => 'activate', :activation_code => '', :controller => 'users'
  map.logout '/logout', :action => 'destroy', :controller => 'sessions'
  map.login '/login', :action => 'new', :controller => 'sessions'
  map.register '/register', :action => 'create', :controller => 'users'
  map.signup '/signup', :action => 'new', :controller => 'users'
  
  # this is the options hash passed to map.resource :users, in a seperate line for readability.
  user_hash = {:except => :new, :member=>{:purge=>:delete, :unsuspend=>:put, :suspend=>:put}}
  ninja_hash = {:member => {:retire    => :put}, :shallow => true, :except => :edit }
  
  # Here I'm repurposing :id, interpreting it as :login instead.
  map.resources :users, user_hash do |user|
    user.resources :ninjas, ninja_hash do |ninja|
      ninja.resources :missions
    end
                           
    user.ancestors '/ancestors', :controller => :users, :action => :ancestors
    user.ancestor  '/ancestors/:id', :controller => :ninjas, :action => :show              
  end


  map.resource :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
