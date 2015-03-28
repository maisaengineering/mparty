Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "admin_venue_feature_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<% if can? :admin, Spree::Admin::VenueFeaturesController %> <%= tab :venue_features,  :url => spree.admin_venue_features_path, :icon => 'icon-th-large' %> <% end %>",
                     :disabled => false)