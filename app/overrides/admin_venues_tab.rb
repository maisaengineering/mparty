Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
    :name => "admin_venues_tab",
    :insert_bottom => "[data-hook='admin_tabs']",
    :text => "<% if can? :admin, Venue %> <%= tab :venues,  :url => spree.admin_venues_path, :icon => 'icon-th-large' %> <% end %>",
    :disabled => false)