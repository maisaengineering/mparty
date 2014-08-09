json.array!(@spree_admin_templates) do |spree_admin_template|
  json.extract! spree_admin_template, :id, :name
  json.url spree_admin_template_url(spree_admin_template, format: :json)
end
