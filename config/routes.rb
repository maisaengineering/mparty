require 'sidekiq/web'
Invitation::Application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  resources :reviews
  mount Sidekiq::Web, at: "/sidekiq"

  Spree::Core::Engine.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
    namespace :admin do
      resources :templates
      resources :venue_categories
      resources :venue_facilities
      resources :venue_features
      resources :venues do
        member do
          get 'add_photos'
          post 'upload_photos'
          delete 'remove_photo'
          get 'add_calendar'
          get 'add_venue_seating_images'
          post 'save_seating_images'
          delete 'remove_seating_photo'
          post 'book_venue'
          delete 'remove_venue_slot'
        end
      end
      get '/bookings'=>"bookings#index"
      get '/booking/show/:id'=>"bookings#show",as: :admin_booking_show
      get '/booking/:id/update/'=>"bookings#update",as: :admin_booking_update
    end
  end
  # resources :templates
  resources :venues,only: [:index,:show] do 
    get 'check_availability',on: :member
    get 'booked_slots',on: :member
    get "map",on: :member
  end  
  resources :pictures do
    delete 'remove_all' ,on: :collection
  end



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

  get "account/show", to: "account#show"
  get "account/edit_profile", to: "account#edit_profile"
  post "account/update_profile", to: "account#update_profile"
  post "account/update_avatar", to: "account#update_avatar"

  get "event/:id/edit_event_design", to: "events#edit_event_design", as: "event_design_edit"
  post "event/:id/update_event_design", to: "events#update_event_design", as: "event_design_update"
  #get "event/:id/edit_photos", to: "pictures#edit_photos", as: "edit_photos"


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

  # request host for invitation to join for private event
  get '/events/:id/inv-request', to: "events#inv_request", as: "ask_host_to_invite"

  post '/events/invite-friends'=>"events#send_invitation", as: :send_invitation

  get '/events/add_guests/:event_id'=>"events#add_guests", as: :add_guests
  get '/events/remove_product_from_wishlist/:product_id'=>"events#remove_product_from_wishlist", as: :remove_product_from_wishlist
  get '/events/:event_id/add_products/'=>"events#add_products", as: :add_products
  get '/calendar/'=>"events#calendar", as: :calendar
  get '/get_my_calendar/'=>"events#get_my_calendar", as: :get_my_calendar



  get '/view_invitation/:invitation_code'=>"invites#show", as: :view_invitation

  resources :invites, only: [:create, :destroy]

  get '/invites/update_invitation'=>"invites#update_invitation", as: :update_invitation

  get '/events/show_invitation/:event_id'=>"events#show_invitation", as: :show_invitation

  get '/invites/join_public_event/:event_id'=>"invites#join_public_event", as: :join_public_event

  ## Wish list ----------------------------------------------------------------
  get '/event/:event_id/whishlist'=>"wishlist#index",as: :event_wishlist
  post '/event/:event_id/wishlist/add_product'=>"wishlist#add_product",as: :add_wished_product_to_wishlist
  delete '/event/:event_id/wishlist/remove_product'=>"wishlist#remove_product",as: :remove_wished_product
  get '/event/:event_id/wishlist/wished_products'=>"wishlist#wished_products"
  get '/event/:event_id/invite-with-wishlist'=>"events#invite_with_wishlist",as: :invite_with_wishlist
  post '/event/:event_id/shipping_address'=>"wishlist#shipping_address",as: :wishlist_shipping_address
  get '/my-wish-lists'=> 'wishlist#my_wish_lists'
  get '/wishlist/:wl_id/wished-product/:wp_id/purchased-users'=>'wishlist#purchased_users',as: :wishlist_purchases

  get '/event/:event_id/add-photos'=>"events#add_photos",as: :add_photos_event
  get '/event/:event_id/invite-friends'=>"events#invite_without_wishlist",as: :invite_without_wishlist
  get '/event/:id/share_on_fb/', to: "events#share_on_fb", as: :share_on_fb

  ## Invited Users List
  get '/event/:id/invited_users_list/', to: "events#invited_users_list", as: :invited_users_list

  get "event/:id/preview", to: "events#preview",as: :event_preview

  # Update quantity of wished product(event is mandatory)
  post '/event/:event_id/wishlist/update-product-quantity'=>"wishlist#update_quantity",as: :update_wished_product_quantity
  ## End Wish list -------------------------------------------------------------

  # Join/Un-join Event(RSVP)
  match '/events/:event_id/join'=>"rsvps#join",as: :join_into_event, via:[:get, :post]
  delete '/events/:event_id/disjoin'=>"rsvps#disjoin",as: :disjoin_from_event

  get '/events/:event_id/event_map' => 'events#event_map',as: :event_map
  #Select state by country
  get '/country/get-states/:country'=>"country#get_states", as: :get_country_states

  # Orders ------------
  get '/account/my-orders'=>"orders#index"

  # mail contacts
  get "/contacts/:provider/contact_callback" => "events#import_and_invite"
  get "/contacts/failure" => "events#import_and_invite"

end
