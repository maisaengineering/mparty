Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "admin_templates_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<% if can? :admin,Spree::Admin::Template  %> <%= tab :templates,  :url => spree.admin_templates_path, :icon => 'icon-th-large' %> <% end %>",
                     :disabled => false)