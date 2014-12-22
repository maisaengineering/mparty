// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require jcarousel.ajax
//= require jcarousel.min
//= require jquery.fancybox
//= require jquery.fancybox-media
//= require bootstrap-datepicker
//= require jquery.timepicker
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require jquery.infinitescroll
//= require jquery.e-calendar


//= require cart
//= require events
//= require comments
//= require pictures

// Visit pages via turbolinks
$(document).on('click', '.viaTurbo',function (e) {
    e.preventDefault()
    Turbolinks.visit($(this).attr('data-url'));
});


$(document).ready(function() {
    //$(".btn_create").on("click",function(){
    $(".alert_wrapper").animate({top:'10px'}, 500);
    setTimeout(function() {
            $(".alert_wrapper").animate({top:'-60px'}, 250)}
        , 3000)
});



