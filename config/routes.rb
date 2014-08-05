Invitation::Application.routes.draw do


  # resources :event_categories

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => "/"



  #Spree::Core::Engine.routes.prepend do
    #root :to => 'user_sessions#new'
  #end
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

  get '/events/fetch_friends'=>"events#fetch_friends"

  resources :events do #, only: [:new, :create, :show, :index]
    resources :comments
    resources :pictures
  end
  post '/events/invite-friends'=>"events#send_invitation", as: :send_invitation

  get '/events/add_guests/:event_id'=>"events#add_guests", as: :add_guests
  get '/events/remove_product_from_wishlist/:product_id'=>"events#remove_product_from_wishlist", as: :remove_product_from_wishlist
  get '/events/:event_id/add_products/'=>"events#add_products", as: :add_products
  get '/calendar/'=>"events#calendar", as: :calendar

  post '/events/add_ship_address'=>"events#add_ship_address", as: :add_ship_address

  get '/view_invitation/:invitation_code'=>"events#view_invitation", as: :view_invitation

  resources :invites, only: [:create, :destroy]
  
  get '/invites/update_invitaion'=>"invites#update_invitaion", as: :update_invitaion

  # resources :rsvps, only: [:create, :destroy]
  #
  # get '/rsvps/rsvp_create'=>"rsvps#create", as: :rsvp_create

end
