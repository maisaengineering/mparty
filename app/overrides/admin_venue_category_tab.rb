Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
    :name => "admin_venue_category_tab",
    :insert_bottom => "[data-hook='admin_tabs']",
    :text => "<% if can? :admin, Spree::Admin::VenuesController %> <%= tab :venue_categories,  :url => spree.admin_venue_categories_path, :icon => 'icon-th-large' %> <% end %>",
    :disabled => false)