source 'https://rubygems.org'

ruby '2.1.2'
gem 'rails', '4.0.4'

gem 'pg'
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

## Jquery -------------------------------------
gem 'jquery-rails', '3.1.1'
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails'
gem 'jquery-turbolinks'
gem 'bootbox-rails', '~>0.4'
#--  End jquery-----------------------------------

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

## Servers
gem 'thin'
gem 'unicorn',group: :production
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# ---------- Spree ----------------------------------
gem 'spree', '2.2.1'
gem 'spree_gateway', git: 'https://github.com/spree/spree_gateway.git', branch: '2-2-stable'
gem 'money', '6.0.1'
# authentication
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-2-stable'
#Spree extension for Social networking login
#gem 'spree_social', github: 'spree/spree_social', branch: 'master'
gem "spree_social", :git => "git://github.com/spree/spree_social.git", branch: '2-2-stable'
#Spree Extension for create wishlist and send it to friends
gem 'spree_wishlist', github: 'spree/spree_wishlist', branch: '2-2-stable'
gem 'spree_email_to_friend', github: 'spree/spree_email_to_friend', branch: '2-2-stable'
gem 'spree_admin_roles_and_access', '~> 1.2.1'
# End ---------- Spree ------------------------------------

# For debugging application
gem 'byebug'

#Brainteree Payment Gateway for spree
#gem 'spree_braintree', :path => "../spree-braintree" #:git => 'git://github.com/rortechie/spree-braintree.git' 
gem 'braintree', '~> 2.30.2'
gem 'haml-rails'
gem 'momentjs-rails', '~> 2.8'
gem 'fullcalendar-rails', '2.1.1.0'
gem 'koala', "~> 1.8.0rc1"
# For Image upload
gem 'carrierwave'
# For Image resizing
# Pls run this if you get issues whil installing rmagick on Ubuntu
# sudo apt-get install libmagickwand-dev
gem "rmagick"
gem 'handlebars'
gem "nested_form"
gem 'letter_opener', group: :development
gem "geocoder"
gem 'fuzzily'
gem 'kaminari'
# gem 'ratyrate'
gem 'ratyrate', :github => 'maisaengineering/ratyrate'

gem 'fog'
gem 'figaro'
gem "squeel"
gem 'gravatar_image_tag'

#HEROKU relates
group :production do
  gem 'rails_12factor'
  gem 'heroku_rails_deflate'
end

gem 'delayed_job_active_record'
gem "daemons"

# Authorization
gem "pundit"

# Mail Contacts
gem 'omnicontacts'

# url content and get video image in VenueUrl for venues
gem 'hpricot'
