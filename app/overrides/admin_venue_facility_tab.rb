Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "admin_venue_facility_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<% if can? :admin, Spree::Admin::VenueFacilitiesController %> <%= tab :venue_facilities,  :url => spree.admin_venue_facilities_path, :icon => 'icon-th-large' %> <% end %>",
                     :disabled => false)