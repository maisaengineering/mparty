
Deface::Override.new(
	:virtual_path =>"spree/shared/_sidebar",
	:name => "remove_sidebar",
	:remove => "aside#sidebar")

Deface::Override.new(
	:virtual_path =>"spree/shared/_nav_bar",
	:name => "remove_search-bar",
	:remove => "li#search-bar")

Deface::Override.new(
	:virtual_path =>"spree/shared/_main_nav_bar",
	:name => "remove_main-nav-bar",
	:remove => "ul#main-nav-bar")