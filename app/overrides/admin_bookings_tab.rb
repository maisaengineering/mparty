Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "admin_bookings_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<% if can? :admin, :booking %> <%= tab :bookings,  :url => spree.admin_bookings_path, :icon => 'icon-th-large' %> <% end %>",
                     :disabled => false)