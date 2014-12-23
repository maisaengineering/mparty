Invitation::Application.routes.draw do
  resources :reviews
  Spree::Core::Engine.routes.draw do
    namespace :admin do
      resources :templates
      resources :venues do
        member do
          get 'add_photos'
          post 'upload_photos'
          delete 'remove_photo'
          get 'add_calendar'
          post 'book_venue'
        end
      end
    end
  end

  # resources :templates
  resources :venues,only: [:index,:show]
  resources :pictures



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

  post '/events/add_ship_address'=>"events#add_ship_address", as: :add_ship_address


  resources :events do #, only: [:new, :create, :show, :index]
    collection do
      get 'update_designs'
      post 'select_venue'
    end
    # resources :comments
    resources :pictures
  end

  resources :comments

  post '/events/invite-friends'=>"events#send_invitation", as: :send_invitation

  get '/events/add_guests/:event_id'=>"events#add_guests", as: :add_guests
  get '/events/remove_product_from_wishlist/:product_id'=>"events#remove_product_from_wishlist", as: :remove_product_from_wishlist
  get '/events/:event_id/add_products/'=>"events#add_products", as: :add_products
  get '/calendar/'=>"events#calendar", as: :calendar


  get '/view_invitation/:invitation_code'=>"events#view_invitation", as: :view_invitation

  resources :invites, only: [:create, :destroy]

  get '/invites/update_invitation'=>"invites#update_invitation", as: :update_invitation

  get '/events/show_invitation/:event_id'=>"events#show_invitation", as: :show_invitation

  get '/invites/join_public_event/:event_id'=>"invites#join_public_event", as: :join_public_event

  ## Wish list ----------------------------------------------------------------
  get '/event/:event_id/whishlist'=>"whishlist#index",as: :event_wishlist
  post '/event/:event_id/wishlist/add_product'=>"whishlist#add_product"
  delete '/event/:event_id/wishlist/remove_product'=>"whishlist#remove_product"
  get '/event/:event_id/wishlist/wished_products'=>"whishlist#wished_products"

  get '/event/:event_id/invite-with-wishlist'=>"events#invite_with_wishlist",as: :invite_with_wishlist



  ## End Wish list -------------------------------------------------------------

  # Products lisitng search ,fileter etc

  # resources :rsvps, only: [:create, :destroy]
  #
  # get '/rsvps/rsvp_create'=>"rsvps#create", as: :rsvp_create

end
