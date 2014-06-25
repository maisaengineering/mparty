
Deface::Override.new(
	:virtual_path =>"spree/shared/_sidebar",
	:name => "remove_sidebar",
	:remove => "aside#sidebar")

Deface::Override.new(
	:virtual_path =>"spree/shared/_nav_bar",
	:name => "remove_search-bar",
	:remove => "li#search-bar")
=begin
Deface::Override.new(
	:virtual_path =>"spree/shared/_main_nav_bar",
	:name => "remove_main-nav-bar",
	:remove => "ul#main-nav-bar")
=end
Deface::Override.new(:virtual_path  => "spree/home/index",
	:replace => "[data-hook='homepage_products']",
	:name => "homepage_events",
	:partial => "spree/home/homepage_events")
	