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
//= require bootbox
//= require jcarousel.ajax
//= require jcarousel.min
//= require jquery.fancybox
//= require jquery.fancybox-media
//= require jquery.datetimepicker
// require bootstrap-datepicker
// require jquery.timepicker
//= require jquery.payment
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require jquery.infinitescroll
//= require moment
//= require fullcalendar
//= require jquery.rateit

//= require cart
//= require events
//= require comments
//= require pictures
//= require reviews
//= require venues
//= require account
//= require wishlist_cart


Turbolinks.pagesCached(0);
// Visit pages via turbolinks
$(document).on('click', '.viaTurbo',function (e) {
    e.preventDefault()
    Turbolinks.visit($(this).attr('data-url'));
});

$(document).on('page:fetch', function () {
    $('.loading-indicator').fadeIn('slow');
});

$(document).on('page:change', function() {
    // hide the loading indicator after page load
    // $("#turbolink_indicator").hide();
});


$(document).on('page:restore', function () {
    $('.loading-indicator').fadeIn('slow')
});


$(document).ready(function() {
    //$(".btn_create").on("click",function(){
    renderFlashMessage()
});

renderFlashMessage = function(){
    $(".alert_wrapper").animate({top:'10px'}, 500);
    setTimeout(function() {
            $(".alert_wrapper").animate({top:'-60px'}, 250)}
        , 4000)
}

// popover and tooltip
$(function () {
    $('[data-toggle="popover"]').popover()
    $('[data-toggle="tooltip"]').tooltip()
})

// End less scroll from railscasts
jQuery(function() {
    if ($('.pagination').length) {
        $(window).scroll(function() {
            var url;
            url = $('.pagination .next a').attr('href');
            if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
                $('.pagination').text('Fetching more...');
                return $.getScript(url);
            }
        });
    }
    return $(window).scroll();
});

$(document).ready(function () {
  $(".td_hide").hide()
})
function showHide(shID) {
  if (document.getElementById(shID)) {
    $(".td_hide").show()
    document.getElementById('hide_when_read_more').style.display = 'none'
    if (document.getElementById(shID+'-show').style.display != 'none') {
      document.getElementById(shID+'-show').style.display = 'none';
      document.getElementById(shID).style.display = 'block';
    }
    else {
      document.getElementById(shID+'-show').style.display = 'inline';
      document.getElementById('hide_when_read_more').style.display = '';
      $(".td_hide").hide()
      document.getElementById(shID).style.display = 'none';
    }
  }
}