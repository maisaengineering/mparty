Deface::Override.new(virtual_path:     "spree/admin/users/index",
                     name:             "admin_user_index_replace_row_actions",
                     replace_contents: "[data-hook='admin_users_index_row_actions']",
                     partial:          "spree/admin/users/index_row_actions",
                     disabled:         false)